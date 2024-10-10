require("config.lazy")
require("config.settings")
require("lazy").setup({
    spec = {
       { import = "plugins" },
    },
    checker = { enabled = true },
})
