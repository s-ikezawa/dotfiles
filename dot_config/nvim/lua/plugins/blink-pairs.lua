return {
  "saghen/blink.pairs",
  version = "*",
  dependencies = {
    "saghen/blink.download",
  },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    mappings = {
      enabled = true,
      cmdline = true,
      disabled_filetypes = {},
      pairs = {},
    },
    highlights = {
      enabled = true,
      cmdline = true,
      groups = {
        "BlinkPairsOrange",
        "BlinkPairsPurple",
        "BlinkPairsBlue",
      },
      unmatched_group = "BlinkPairsUnmatched",
      matchparen = {
        enabled = true,
        cmdline = true,
        include_surrounding = false,
        group = "BlinkPairsMatchParen",
        priority = 250,
      },
    },
    debug = false,
  },
}

