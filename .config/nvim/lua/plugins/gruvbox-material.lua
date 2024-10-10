return {
    "sainnhe/gruvbox-material",
    init = function()
        vim.g.gruvbox_material_background = 'medium'
        vim.g.gruvbox_material_better_performance = 1
    end,
    config = function()
        vim.cmd.colorscheme("gruvbox-material")
    end
}
