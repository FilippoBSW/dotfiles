return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function(_, opts)
        local wk = require('which-key')
        local builtin = require('telescope.builtin')

        local function is_git_repo()
            vim.fn.system('git rev-parse --is-inside-work-tree')
            return vim.v.shell_error == 0
        end

        local function get_git_root()
            local dot_git_path = vim.fn.finddir(".git", ".;")
            return vim.fn.fnamemodify(dot_git_path, ":h")
        end

        local function find_project_file()
            local opts = {}
            vim.fn.system('git rev-parse --is-inside-work-tree')
            if vim.v.shell_error == 0 then
                require 'telescope.builtin'.git_files(opts)
            else
                require 'telescope.builtin'.find_files(opts)
            end
        end

        local function search_project_files()
            local opts = {}
            if is_git_repo() then
                opts = { cwd = get_git_root(), }
            end
            require('telescope.builtin').live_grep(opts)
        end

        local function toggle_and_focus_undotree()
            vim.cmd('UndotreeToggle')
            vim.cmd('UndotreeFocus')
        end

        wk.setup()
        wk.add({
            { "<C-c>u", toggle_and_focus_undotree, desc = "toggle_and_focus_undotree" },

            { "<leader>c", function() builtin.buffers({sort_lastused = true, ignore_current_buffer = true}) end, desc = "Buffers" },
            { "<leader>o", function() require('telescope').extensions.zoxide.list() end, { desc = "Zoxide directories" } },
            { "<leader>d", function() vim.cmd("wincmd w") end, desc = "Move to next window" },
            { "<leader>w", function() vim.cmd("Oil") end, desc = "Buffers" },

            { "<leader>sh", find_project_file, desc = "Find project file" },
            { "<leader>sa", function() vim.cmd("Telescope file_browser prompt_path=true grouped=true select_buffer=true") end, desc = "File browser" },

            { "<leader>t", group = "search" },
            { "<leader>th", search_project_files, desc = "Search project files" },
            { "<leader>tf", function() vim.cmd("Telescope current_buffer_fuzzy_find") end, desc = "Grep current file" },

            { "<leader>h", group = "navigate" },
            { "<leader>hc", function() vim.cmd("quit") end, desc = "Delete window" },
            { "<leader>hd", function() vim.cmd("only") end, desc = "Close all others" },
            { "<leader>ht", function() vim.cmd("split") end, desc = "Split horizontally and follow" },
            { "<leader>hs", function() vim.cmd("vsplit") end, desc = "Split vertically and follow" },

            { "<leader>a", group = "buffer" },
            { "<leader>ac", function() vim.cmd("bp") vim.cmd("bd #") end, desc = "Close buffer" },
            { "<leader>at", function() vim.cmd("bprevious") end, desc = "Previous buffer" },
            { "<leader>as", function() vim.cmd("bnext") end, desc = "Next buffer" },
        })
    end
}
