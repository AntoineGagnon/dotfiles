return {
  dir = "/Users/antoinegagnon/Code/ios.nvim",
  lazy = false,
  config = function()
    require("ios").setup({
      use_xcpretty = true,
      log_level = "debug",
    })
  end,
}
