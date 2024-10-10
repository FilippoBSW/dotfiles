return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ':TSUpdate',
    opts = {
        sync_install = true,
        auto_install = true,
        highlight = {
            enable = true
        },
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end
}
