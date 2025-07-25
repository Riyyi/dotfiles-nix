local K = vim.keymap.set

local builtin
local bs = require("core.buffers")
local wk = require("which-key")

local F = require("keybind-functions")

local M = {}

--------------------------------------------
--- Keybindings ---

M.setup = function()
	F.setup()

	-- Prevent dependency loop
	builtin = require("telescope.builtin")

	-- Change default behavior
	K("n", "Y", "y$")
	K("v", "p", "pgvy")

	K("n", "J", "mzJ`z")    -- dont move cursor to end of line

	K("n", "<C-d>", "<C-d>zz") -- stay in the middle
	K("n", "<C-u>", "<C-u>zz")
	K("n", "n", "nzzzv")
	K("n", "N", "Nzzzv")

	K("x", "p", "\"_dP") -- dont overwrite clipboard when pasting visually

	-- Remap for dealing with word wrap
	K("n", "k", [[v:count == 0 ? "gk" : "k"]], { expr = true, silent = true })
	K("n", "j", [[v:count == 0 ? "gj" : "j"]], { expr = true, silent = true })

	-- Tab/Shift+Tab functionality
	K("n", "<Tab>", ">>_")
	K("n", "<S-Tab>", "<<_")
	K("i", "<S-Tab>", "<C-D>")
	K("v", "<Tab>", ">gv")
	K("v", "<S-Tab>", "<gv")

	-- Move highlighted blocks
	K("v", "J", ":m '>+1<CR>gv=gv")
	K("v", "K", ":m '<-2<CR>gv=gv")

	-- Switch to previous buffer
	-- Meta key
	K("n", "<M-`>", "<C-6>")
	-- macOS command key
	K("n", "<D-`>", "<C-6>")

	-- Center buffer with Ctrl+L
	K("n", "<C-l>", "zz")

	-- Close buffer with Alt-w
	-- Meta key
	K("n", "<M-w>", F.buffer_close)
	-- macOS command key
	K("n", "<D-w>", F.buffer_close)

	-- Hungry delete
	K("i", "<BS>", F.hungry_delete_backspace())
	K("i", "<Del>", F.hungry_delete())

	-- Navigation
	-- Meta key
	K("n", "<M-h>", bs.buffer_move_left)
	K("n", "<M-j>", bs.buffer_group_move_down)
	K("n", "<M-k>", bs.buffer_group_move_up)
	K("n", "<M-l>", bs.buffer_move_right)
	K("n", "<M-H>", bs.buffer_swap_left)
	K("n", "<M-L>", bs.buffer_swap_right)
	-- macOS command key
	K("n", "<D-h>", bs.buffer_move_left)
	K("n", "<D-j>", bs.buffer_group_move_down)
	K("n", "<D-k>", bs.buffer_group_move_up)
	K("n", "<D-l>", bs.buffer_move_right)
	K("n", "<D-H>", bs.buffer_swap_left)
	K("n", "<D-L>", bs.buffer_swap_right)

	-- Terminal
	K("n", "<C-\\>", F.toggle_term)
	K("t", "<C-\\>", F.toggle_term)

	----------------------------------------
	--- Leader keys ---


	K("n", "<leader><space>", builtin.commands, { desc = "Execute command" })


	F.wk("<leader>b", "buffer/bookmark")
	K("n", "<leader>bb", builtin.buffers, { desc = "Switch buffer" })
	K("n", "<leader>bB", bs.buffer_pick_buffer, { desc = "Switch tab group buffer" })
	K("n", "<leader>bd", F.buffer_dashboard, { desc = "Dashboard" })


	F.wk("<leader>c", "comment")
	-- numToStr/Comment.nvim
	K("n", "<leader>cc", "<Plug>(comment_toggle_linewise_current)", { desc = "Comment toggle linewise" })
	K("n", "<leader>cp", "<Plug>(comment_toggle_blockwise_current)", { desc = "Comment toggle blockwise" })
	K("x", "<leader>cc", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment toggle linewise (visual)" })
	K("x", "<leader>cp", "<Plug>(comment_toggle_blockwise_visual)", { desc = "Comment toggle blockwise (visual)" })


	F.wk("<leader>e", "eval")
	K("n", "<leader>eb", ":w<CR>:source %<CR>", { desc = "Evaluate buffer" })


	F.wk("<leader>f", "file")
	K("n", "<leader>fc", F.file_config, { desc = "Config file" })
	K("n", "<leader>ff", F.file_find, { desc = "Find file" })
	K("n", "<leader>fh", F.file_find_home, { desc = "Find file in ~" })
	K("n", "<leader>fr", F.file_find_recent, { desc = "Find recent file" })
	K("n", "<leader>fs", F.file_save, { desc = "Save file" })


	F.wk("<leader>h", "help")
	K("n", "<leader>hh", builtin.help_tags, { desc = "Describe" })
	K("n", "<leader>hk", builtin.keymaps, { desc = "Describe key" })
	K("n", "<leader>hm", builtin.man_pages, { desc = "Describe manpage" })


	F.wk("<leader>g", "goto")
	K("n", "<leader>ge", F.goto_trouble, { desc = "Goto trouble" })
	K("n", "<leader>gt", F.goto_todos_telescope, { desc = "Goto todos (Telescope)" })
	K("n", "<leader>gT", F.goto_todos_trouble, { desc = "Goto todos (Trouble)" })


	F.wk("<leader>p", "project")
	K("n", "<leader>pf", F.project_file, { desc = "Find project file" })
	K("n", "<leader>pg", F.project_grep, { desc = "Find in project" })
	K("n", "<leader>pp", F.project_list, { desc = "List projects" })


	F.wk("<leader>s", "search")
	K("n", "<leader>ss", F.search_buffer, { desc = "Search buffer" })
	K("n", "<leader>sq", ":nohlsearch<CR>", { desc = "Stop search", silent = true })


	F.wk("<leader>t", "tabs/toggle")
	K("n", "<leader>tg", bs.buffer_pick_group, { desc = "Switch tab group" })


	F.wk("<leader>v", "git") -- version control
	K("n", "<leader>vr", F.vc_select_repo, { desc = "Select repo" })
	K("n", "<leader>vv", F.vc_status, { desc = "Neogit status" })


	K({ "n", "v" }, "<leader>w", "<C-W>", { remap = true }) -- keymap and which-key should *both* be triggered
	wk.add({
		{
			mode = { "n", "v" },
			{ "<leader>w", group = "window" },
			{ "<leader>w+", desc = "Increase height" },
			{ "<leader>w-", desc = "Decrease height" },
			{ "<leader>w<", desc = "Decrease width" },
			{ "<leader>w=", desc = "Equally high and wide" },
			{ "<leader>w>", desc = "Increase width" },
			{ "<leader>wT", desc = "Break out into a new tab" },
			{ "<leader>w_", desc = "Max out the height" },
			{ "<leader>wh", desc = "Go to the left window" },
			{ "<leader>wj", desc = "Go to the down window" },
			{ "<leader>wk", desc = "Go to the up window" },
			{ "<leader>wl", desc = "Go to the right window" },
			{ "<leader>wo", desc = "Close all other windows" },
			{ "<leader>wq", desc = "Quit a window" },
			{ "<leader>ws", desc = "Split window" },
			{ "<leader>wv", desc = "Split window vertically" },
			{ "<leader>ww", desc = "Switch windows" },
			{ "<leader>wx", desc = "Swap current with next" },
			{ "<leader>w|", desc = "Max out the width" },
		},
	})
	-- https://github.com/folke/which-key.nvim/issues/270
	-- https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/misc.lua
end

--------------------------------------------
--- Plugin specific ---

-- This function gets run when an LSP connects to a particular buffer.
M.lspconfig_on_attach = function(_, bufnr)
	local nnoremap = function(keys, func, desc)
		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	F.wk("<leader>l", "lsp", bufnr)
	nnoremap("<leader>la", vim.lsp.buf.code_action, "Code action")
	nnoremap("<leader>lf", F.lsp_format_buffer, "Format buffer")
	nnoremap("<leader>lr", vim.lsp.buf.rename, "Rename")

	nnoremap("<leader>ld", "<cmd>Lspsaga hover_doc<CR>", "Show documentation")
	-- vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga hover_doc<CR>", { desc = "Show documentation" })

	F.wk("<leader>lg", "goto", bufnr)
	nnoremap("<leader>lga", builtin.lsp_dynamic_workspace_symbols, "Workspace symbols")
	nnoremap("<leader>lgd", vim.lsp.buf.declaration, "Declaration")
	nnoremap("<leader>lgg", vim.lsp.buf.definition, "Definition") -- builtin.lsp_definitions
	nnoremap("<leader>lgi", builtin.lsp_implementations, "Implementation")
	nnoremap("<leader>lgr", builtin.lsp_references, "References")
	nnoremap("<leader>lgs", builtin.lsp_document_symbols, "Document symbols")
	nnoremap("<leader>lgt", builtin.lsp_type_definitions, "Type definition")

	-- See `:help K` for why this keymap
	nnoremap("K", vim.lsp.buf.hover, "Hover Documentation")
	nnoremap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
end

-- Keybindings for nvim-cmp popup
M.nvim_cmp = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	return cmp.mapping.preset.insert({
		-- Meta key
		["<M-h>"] = cmp.mapping.abort(),
		["<M-j>"] = cmp.mapping.select_next_item(),
		["<M-k>"] = cmp.mapping.select_prev_item(),
		["<M-l>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		-- macOS command key
		["<D-h>"] = cmp.mapping.abort(),
		["<D-j>"] = cmp.mapping.select_next_item(),
		["<D-k>"] = cmp.mapping.select_prev_item(),
		["<D-l>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),

		["<Esc>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-Space>"] = cmp.mapping.complete(),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	})
end

-- Telescope picker generic mappings
M.telescope_default_mappings = function()
	local actions = require("telescope.actions")
	return {
		n = {
			-- Meta key
			["<M-h>"] = actions.close,
			["<M-j>"] = actions.move_selection_next,
			["<M-k>"] = actions.move_selection_previous,
			["<M-l>"] = actions.select_default,
			-- macOS command key
			["<D-h>"] = actions.close,
			["<D-j>"] = actions.move_selection_next,
			["<D-k>"] = actions.move_selection_previous,
			["<D-l>"] = actions.select_default,
		},
		i = {
			-- Meta key
			["<M-h>"] = actions.close,
			["<M-j>"] = actions.move_selection_next,
			["<M-k>"] = actions.move_selection_previous,
			["<M-l>"] = actions.select_default,
			-- macOS command key
			["<D-h>"] = actions.close,
			["<D-j>"] = actions.move_selection_next,
			["<D-k>"] = actions.move_selection_previous,
			["<D-l>"] = actions.select_default,

			["<Tab>"] = actions.select_default,
		}
	}
end

-- Keybindings for toggleterm.nvim
M.toggleterm_nvim = function()
	local keymaps = function()
		local opts = { buffer = 0 }
		K("t", "<Esc>", [[<C-\><C-n>]], opts)
	end

	vim.api.nvim_create_autocmd("TermOpen", {
		pattern = "term://*toggleterm#*",
		callback = keymaps,
	})
end

return M
