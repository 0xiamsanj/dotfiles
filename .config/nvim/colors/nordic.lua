-- ~/.config/nvim/colors/nordic.lua
-- Nordic blue: dark blue-gray surfaces, pastel blue accent.

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') == 1 then vim.cmd('syntax reset') end

vim.o.termguicolors = true
vim.g.colors_name = 'nordic'

local c = {
	bg       = '#242933',
	bg_soft  = '#2e3440',
	bg_float = '#2e3440',
	fg       = '#d8dee9',
	fg_dim   = '#81a1c1',
	gray     = '#616e88',
	line     = '#4c566a',
	accent   = '#a1baf0',
	deep     = '#88c0d0',
	sel      = '#434c5e',
	sel_bg   = '#4c6a92',
	red      = '#bf616a',
	black    = '#242933',
}

local function hl(group, spec) vim.api.nvim_set_hl(0, group, spec) end

-- base
hl('Normal', { fg = c.fg, bg = c.bg })
hl('NormalNC', { fg = c.fg_dim, bg = c.bg })
hl('NonText', { fg = c.gray })
hl('EndOfBuffer', { fg = c.bg })
hl('SpecialKey', { fg = c.gray })
hl('Whitespace', { fg = c.line })

-- cursor & lines
hl('Cursor', { fg = c.black, bg = c.accent })
hl('lCursor', { fg = c.black, bg = c.accent })
hl('TermCursor', { fg = c.black, bg = c.accent })
hl('CursorLine', { bg = c.bg_soft })
hl('CursorColumn', { bg = c.bg_soft })
hl('ColorColumn', { bg = c.bg_soft })
hl('LineNr', { fg = '#4c566a' })
hl('CursorLineNr', { fg = c.accent, bold = true })
hl('SignColumn', { fg = c.gray, bg = c.bg })
hl('FoldColumn', { fg = c.gray, bg = c.bg })
hl('Folded', { fg = c.gray, bg = c.bg_soft })

-- selection / search
hl('Visual', { fg = c.fg, bg = c.sel_bg })
hl('VisualNOS', { fg = c.fg, bg = c.sel_bg })
hl('Search', { fg = c.fg, bg = c.sel_bg })
hl('IncSearch', { fg = c.fg, bg = c.sel_bg })
hl('CurSearch', { fg = c.black, bg = c.deep })
hl('MatchParen', { fg = c.accent, bold = true, underline = true })

-- UI
hl('StatusLine', { fg = c.fg, bg = '#2e3440' })
hl('StatusLineNC', { fg = c.gray, bg = c.bg })
hl('WinSeparator', { fg = c.line })
hl('VertSplit', { fg = c.line })
hl('Pmenu', { fg = c.fg, bg = c.bg_float })
hl('PmenuSel', { fg = c.fg, bg = c.sel_bg })
hl('PmenuSbar', { bg = c.line })
hl('PmenuThumb', { bg = c.gray })
hl('NormalFloat', { fg = c.fg, bg = c.bg_float })
hl('FloatBorder', { fg = c.line, bg = c.bg_float })
hl('FloatTitle', { fg = c.accent, bold = true })
hl('TabLine', { fg = c.gray, bg = c.bg })
hl('TabLineFill', { bg = c.bg })
hl('TabLineSel', { fg = c.fg, bg = c.sel_bg, bold = true })
hl('WildMenu', { fg = c.fg, bg = c.sel_bg })
hl('Title', { fg = c.accent, bold = true })
hl('Directory', { fg = c.accent })
hl('QuickFixLine', { bg = c.sel })
hl('Question', { fg = c.accent })
hl('MoreMsg', { fg = c.accent })
hl('ModeMsg', { fg = c.fg })
hl('MsgArea', { fg = c.fg })
hl('MsgSeparator', { fg = c.line })
hl('ErrorMsg', { fg = c.red })
hl('WarningMsg', { fg = c.accent })
hl('Todo', { fg = c.fg, bg = c.sel_bg, bold = true })
hl('Error', { fg = c.red, bold = true })
hl('WinBar', { fg = c.fg_dim, bg = c.bg })
hl('WinBarNC', { fg = c.gray, bg = c.bg })

-- syntax
hl('Comment', { fg = c.gray, italic = true })
hl('Constant', { fg = c.deep })
hl('String', { fg = c.fg })
hl('Character', { fg = c.fg })
hl('Number', { fg = c.accent })
hl('Float', { fg = c.accent })
hl('Boolean', { fg = c.accent })
hl('Identifier', { fg = c.fg })
hl('Function', { fg = c.accent, bold = true })
hl('Statement', { fg = c.deep })
hl('Conditional', { fg = c.deep })
hl('Repeat', { fg = c.deep })
hl('Label', { fg = c.deep })
hl('Operator', { fg = c.fg_dim })
hl('Keyword', { fg = c.deep })
hl('Exception', { fg = c.deep })
hl('PreProc', { fg = c.fg_dim })
hl('Include', { fg = c.fg_dim })
hl('Define', { fg = c.fg_dim })
hl('Macro', { fg = c.fg_dim })
hl('PreCondit', { fg = c.fg_dim })
hl('Type', { fg = c.accent })
hl('StorageClass', { fg = c.accent })
hl('Structure', { fg = c.accent })
hl('Typedef', { fg = c.accent })
hl('Special', { fg = c.accent })
hl('SpecialChar', { fg = c.accent })
hl('Tag', { fg = c.accent })
hl('Delimiter', { fg = c.fg_dim })
hl('SpecialComment', { fg = c.gray })
hl('Debug', { fg = c.red })
hl('Underlined', { fg = c.fg, underline = true })
hl('Ignore', { fg = c.gray })
hl('Added', { fg = c.accent })
hl('Changed', { fg = c.deep })
hl('Removed', { fg = c.red })

-- diagnostics
hl('DiagnosticError', { fg = c.red })
hl('DiagnosticWarn', { fg = c.accent })
hl('DiagnosticInfo', { fg = c.deep })
hl('DiagnosticHint', { fg = c.gray })
hl('DiagnosticOk', { fg = c.fg })
hl('DiagnosticUnderlineError', { undercurl = true, sp = c.red })
hl('DiagnosticUnderlineWarn', { undercurl = true, sp = c.accent })
hl('DiagnosticUnderlineInfo', { undercurl = true, sp = c.deep })
hl('DiagnosticUnderlineHint', { undercurl = true, sp = c.gray })
hl('DiagnosticVirtualTextError', { fg = c.red, bg = c.bg_soft })
hl('DiagnosticVirtualTextWarn', { fg = c.accent, bg = c.bg_soft })
hl('DiagnosticVirtualTextInfo', { fg = c.deep, bg = c.bg_soft })
hl('DiagnosticVirtualTextHint', { fg = c.gray, bg = c.bg_soft })

-- diffs
hl('DiffAdd', { fg = c.accent })
hl('DiffChange', { fg = c.deep })
hl('DiffDelete', { fg = c.red })
hl('DiffText', { bg = c.sel })

-- spell
hl('SpellBad', { undercurl = true, sp = c.red })
hl('SpellCap', { undercurl = true, sp = c.accent })
hl('SpellLocal', { undercurl = true, sp = c.deep })
hl('SpellRare', { undercurl = true, sp = c.gray })
