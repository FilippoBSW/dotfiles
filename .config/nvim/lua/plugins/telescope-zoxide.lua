return {
    'jvgrootveld/telescope-zoxide',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local telescope = require('telescope')
        local z_utils = require("telescope._extensions.zoxide.utils")

        telescope.setup({
            extensions = {
                zoxide = {
                    prompt_title = "[ Zoxide Directory List ]",
                    mappings = {
                        default = {
                            action = function(selection)
                                vim.cmd.cd(selection.path)
                                vim.notify("Changed directory to: " .. vim.fn.getcwd(), vim.log.levels.INFO)
                                vim.defer_fn(function()
                                                 require('oil').open(selection.path)
                                                 vim.fn.system("zoxide add " .. vim.fn.shellescape(selection.path))
                                             end, 10)
                            end,
                        },
                    }
                }
            }
        })
        vim.keymap.set('n', '<leader>z', function()
                                             require('telescope').extensions.zoxide.list()
                                         end, { desc = "Zoxide directories" })
        telescope.load_extension('zoxide')
    end
}
