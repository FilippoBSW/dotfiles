vim.g.mapleader                   = ' '
vim.g.localleader                 = ' '

vim.opt.syntax         = 'on'
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.swapfile       = false
vim.opt.autoindent     = true
vim.opt.errorbells     = false
vim.opt.autoindent     = true
vim.opt.smartcase      = true
vim.opt.smartindent    = true
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.mouse          = 'a'
vim.opt.background     = 'dark'
vim.opt.backup         = false
vim.opt.writebackup    = false
vim.opt.encoding       = 'utf-8'
vim.opt.hidden         = true
vim.opt.cmdheight      = 2
vim.opt.updatetime     = 300
vim.opt.wrap           = false
vim.opt.ignorecase     = true
vim.opt.shortmess      = 'c'
vim.opt.clipboard      = 'unnamedplus'
vim.opt.hlsearch       = true
vim.opt.incsearch      = true
vim.opt.termguicolors  = true
vim.opt.scrolloff      = 8
vim.opt.autochdir      = true
vim.opt.autoread       = true
vim.opt.showtabline    = 0
vim.opt.guicursor      = ''
vim.opt.cursorline     = true
vim.opt.termguicolors  = true
vim.opt.timeout        = true
vim.opt.timeoutlen     = 300
vim.opt.splitright     = false
vim.opt.splitbelow     = false

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = { '*' },
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = { '*' },
    callback = function()
        if next(vim.lsp.buf_get_clients()) ~= nil then
            vim.cmd([[LspZeroFormat]])
        end
    end,
})

vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
    pattern = "*",
    command = "checktime"
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        vim.bo.commentstring = "// %s"
    end,
})
