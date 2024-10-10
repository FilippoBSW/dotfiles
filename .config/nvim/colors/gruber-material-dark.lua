local colors = {
    white     = "#ffffff",
    black     = "#000000",
    fg0       = "#e4e4ef",
    bg0       = "#181818",
    bg1       = "#282828",
    bg2       = "#3e3b3c",
    bg3       = "#484848",
    bg4       = "#52494e",
    bg_red    = "#493030",
    red       = "#dc6363",
    bg_green  = "#304038",
    green     = "#81b29a",
    bg_yellow = "#463e2a",
    yellow    = "#d2b55b",
    brown     = "#7c6f64",
    bg_quartz = "#353a39",
    quartz1   = "#6b7570",
    quartz    = "#95a99f",
    niagara0  = "#303540",
    niagara1  = "#565f73",
    niagara2  = "#96a6c8",
    wisteria  = "#9e95c7",
}

local function set_highlights()
    local hl = vim.api.nvim_set_hl
    local opts = {default = false}

    hl(0, "Normal", { fg = colors.fg0, bg = colors.bg0 })
    hl(0, "Cursor", { fg = colors.wisteria, bg = colors.fg0 })
    hl(0, "Visual", { bg = colors.bg2 })
    hl(0, "Search", { bg = colors.bg2 })
    hl(0, "CursorLine", { bg = colors.bg1 })
    hl(0, "CursorColumn", { bg = colors.bg1 })
    hl(0, "LineNr", { fg = colors.bg4 })
    hl(0, "CursorLineNr", { fg = colors.fg0 })
    hl(0, "VertSplit", { fg = colors.bg2 })
    hl(0, "WinSeparator", { fg = colors.bg2 })
    hl(0, "StatusLine", { fg = colors.fg0, bg = colors.bg1 })
    hl(0, "StatusLineNC", { fg = colors.bg4, bg = colors.bg1 })
    hl(0, "Pmenu", { fg = colors.fg0, bg = colors.bg1 })
    hl(0, "PmenuSel", { bg = colors.bg2 })
    hl(0, "PmenuThumb", { bg = colors.bg2 })
    hl(0, "WildMenu", { fg = colors.fg0, bg = colors.bg2 })
    hl(0, "SignColumn", { bg = colors.bg0 })
    hl(0, "Title", { fg = colors.quartz })
    hl(0, "FloatBorder", { fg = colors.bg2 })
    hl(0, "NormalFloat", { bg = colors.bg1 })

    hl(0, "Comment", { fg = colors.brown })
    hl(0, "Constant", { fg = colors.fg0 })
    hl(0, "String", { fg = colors.green })
    hl(0, "Character", { fg = colors.green })
    hl(0, "Number", { fg = colors.fg0 })
    hl(0, "Boolean", { fg = colors.quartz })
    hl(0, "Float", { fg = colors.fg0 })
    hl(0, "Identifier", { fg = colors.fg0 })
    hl(0, "Function", { fg = colors.niagara2 })
    hl(0, "Statement", { fg = colors.wisteria })
    hl(0, "Conditional", { fg = colors.wisteria })
    hl(0, "Repeat", { fg = colors.wisteria })
    hl(0, "Label", { fg = colors.wisteria })
    hl(0, "Operator", { fg = colors.fg0 })
    hl(0, "Keyword", { fg = colors.wisteria })
    hl(0, "Exception", { fg = colors.wisteria })
    hl(0, "PreProc", { fg = colors.quartz })
    hl(0, "Include", { fg = colors.wisteria })
    hl(0, "Define", { fg = colors.wisteria })
    hl(0, "Macro", { fg = colors.wisteria })
    hl(0, "Type", { fg = colors.quartz })
    hl(0, "StorageClass", { fg = colors.quartz })
    hl(0, "Structure", { fg = colors.quartz })
    hl(0, "Typedef", { fg = colors.quartz })
    hl(0, "Special", { fg = colors.quartz })
    hl(0, "SpecialComment", { fg = colors.brown })
    hl(0, "Underlined", { underline = true })
    hl(0, "Bold", { bold = true })
    hl(0, "Italic", { italic = true })
    hl(0, "Todo", { fg = colors.fg0, bg = colors.bg_red })

    hl(0, "DiagnosticError", { fg = colors.red })
    hl(0, "DiagnosticWarn", { fg = colors.wisteria })
    hl(0, "DiagnosticInfo", { fg = colors.quartz })
    hl(0, "DiagnosticHint", { fg = colors.green })

    hl(0, "MatchParen", { fg = colors.red })
    hl(0, "Directory", { fg = colors.niagara2 })
    hl(0, "Question", { fg = colors.green })
    hl(0, "MoreMsg", { fg = colors.green })
    hl(0, "ErrorMsg", { fg = colors.red })
    hl(0, "WarningMsg", { fg = colors.wisteria })
    hl(0, "ModeMsg", { fg = colors.fg0 })
    hl(0, "SpecialKey", { fg = colors.quartz })
    hl(0, "NonText", { fg = colors.bg4 })
    hl(0, "Whitespace", { fg = colors.bg3 })
    hl(0, "Folded", { fg = colors.fg0, bg = colors.bg1 })
    hl(0, "FoldColumn", { bg = colors.bg0 })

    hl(0, "LspReferenceText", { bg = colors.bg2 })
    hl(0, "LspReferenceRead", { bg = colors.bg2 })
    hl(0, "LspReferenceWrite", { bg = colors.bg2 })
    hl(0, "LspSignatureActiveParameter", { fg = colors.yellow, bg = colors.bg2 })
end

local function load()
    vim.o.background = "dark"
    set_highlights()
end

load()

return {
    load = load,
}
