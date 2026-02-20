return {
  "AntoineGagnon/android.nvim",
  lazy = false,
  config = function()
    require("android").setup({
      log_level = "D",
      filter_by_app = true,
    })
  end,
}
