-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- kotlin-lsp has no Bazel support, so instant-android's workspace.json (see
-- ~/.config/nvim/tools/kotlin-workspace/gen_workspace.py) stands in for it.
-- It's derived from Android Studio's ASwB sync output and goes stale every
-- time that sync reruns, so keep it in sync automatically.
local kotlin_workspace = {
  repo = vim.fn.expand("~/src/instant-android"),
  iml = vim.fn.expand("~/StudioProjects/instant-android/.blaze/modules/.workspace.iml"),
  json = vim.fn.expand("~/src/instant-android/workspace.json"),
  script = vim.fn.expand("~/.config/nvim/tools/kotlin-workspace/gen_workspace.py"),
}

local function kotlin_workspace_in_repo()
  local buf_path = vim.fn.expand("%:p")
  return vim.startswith(buf_path, kotlin_workspace.repo .. "/") or vim.fn.getcwd() == kotlin_workspace.repo
end

local function kotlin_workspace_is_stale()
  local iml_stat = vim.uv.fs_stat(kotlin_workspace.iml)
  if not iml_stat then
    return false -- no ASwB sync yet, nothing to regenerate from
  end
  local json_stat = vim.uv.fs_stat(kotlin_workspace.json)
  return not json_stat or iml_stat.mtime.sec > json_stat.mtime.sec
end

local refreshing = false

local function kotlin_workspace_refresh(restart)
  if refreshing then
    return
  end
  refreshing = true
  vim.system({ "python3", kotlin_workspace.script }, { text = true }, function(result)
    vim.schedule(function()
      refreshing = false
      if result.code ~= 0 then
        vim.notify("kotlin-lsp workspace refresh failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
        return
      end
      if restart then
        vim.notify(vim.trim(result.stdout) .. "\nRestarting kotlin_lsp...", vim.log.levels.INFO)
        vim.cmd("LspRestart kotlin_lsp")
      else
        vim.notify(
          vim.trim(result.stdout) .. "\nRun :KotlinWorkspaceRefresh (or :LspRestart kotlin_lsp) to pick it up.",
          vim.log.levels.WARN
        )
      end
    end)
  end)
end

vim.api.nvim_create_user_command("KotlinWorkspaceRefresh", function()
  kotlin_workspace_refresh(true)
end, { desc = "Regenerate instant-android's kotlin-lsp workspace.json and restart kotlin_lsp" })

local function kotlin_workspace_check()
  if kotlin_workspace_in_repo() and kotlin_workspace_is_stale() then
    kotlin_workspace_refresh(false)
  end
end

-- Polled on a timer rather than FocusGained/DirChanged: those events are easy
-- to get wrong (they can fire far more often than expected depending on
-- terminal/multiplexer) and kotlin_workspace_refresh spawns a subprocess per
-- call, so a misfiring event handler turns into a runaway process storm. A
-- timer bounds the worst case to one check per interval, no matter what the
-- terminal does. 20s is frequent enough to catch a fresh ASwB sync quickly;
-- :KotlinWorkspaceRefresh covers the impatient case.
kotlin_workspace_check()
local kotlin_workspace_timer = vim.uv.new_timer()
kotlin_workspace_timer:start(20000, 20000, vim.schedule_wrap(kotlin_workspace_check))
