return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    opts = {
        defaults = {
            sorting_strategy = 'ascending',
            layout_config = {
                prompt_position = 'top',
            },
        },
        pickers = {
            find_files = {
                hidden = true,
            },
            live_grep = {
                additional_args = function(opts)
                    return { '--hidden' }
                end
            },
        },
    }
}
