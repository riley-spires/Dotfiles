local vim = vim

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Move away from lazy and go towards vim.pack
-- To fix timeout issue, delete folder from stdpath("data")\site\core\pack\opt\{package_name}
require("config.plugins")
require("config.themes")

local themes = {"material", "gruber-darker"}
local theme = 2

vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.colorcolumn = "90"

vim.g.material_style = "palenight"
vim.g.zig_fmt_autosave = 0
vim.cmd("colorscheme " .. themes[theme])

vim.g.compile_mode = {
	baleia_setup = true,
}

-- Needed for vim 0.11.X to see errors properly
vim.diagnostic.config({
    virtual_text = true,
})

require("nvim-treesitter.configs").setup({
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
	},
	indent = { enable = true },
})

require('material').setup {
	contrast = {
		terminal = true,
	},
}

vim.keymap.set('n', "<M-n>", "<cmd>nohlsearch<CR>")
vim.keymap.set('n', "<leader>ng", "<cmd>LazyGit<CR>")
vim.keymap.set('n', "<leader>x", "<cmd>Ex<CR>")

require("telescope").setup()
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>gf', builtin.git_files)
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>gr', builtin.live_grep)

local neogen = require("neogen")

vim.keymap.set('n', '<leader>nf', function() neogen.generate({ type = "func" }) end)
vim.keymap.set('n', '<leader>nc', function() neogen.generate({ type = "class" }) end)

local harpoon = require("harpoon")
harpoon.setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>j", function() harpoon:list():next() end)
vim.keymap.set("n", "<leader>k", function() harpoon:list():prev() end)

for i = 1, 9, 1 do
	vim.keymap.set("n", string.format("<leader>%d", i), function() harpoon:list():select(i) end)
end
vim.keymap.set("n", "<leader>0", function() harpoon:list():select(10) end)

local cmp = require("cmp")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup {
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {

	},
	mapping = cmp.mapping.preset.insert {
		['<tab>'] = cmp.mapping.confirm({ select = true }),
		["<M-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<M-k>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
        ["<M-a>"] = cmp.mapping.abort(),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "vsnip" },
	}, {
		{ name = "buffer" },
	}) 
}

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" }
	}
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})

-- LSP Keybinds
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>rf", vim.lsp.buf.format, opts)

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)


require("mason").setup()
require("mason-lspconfig").setup()
require("autoclose").setup()
-- require("neogit").setup()

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Manual setup of clangd for arm64, other platforms use Mason
vim.lsp.enable("clangd")

-- Manual setup of rust-analyzer for arm64, other platforms use Mason
vim.lsp.enable("rust_analyzer")
