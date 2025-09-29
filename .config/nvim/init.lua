vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.showmode = false

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true

vim.opt.undofile = true
vim.opt.swapfile = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }

-- show replace substitution live
vim.opt.inccommand = "split"

vim.opt.scrolloff = 7
vim.opt.sidescrolloff = 7

local TAB_WIDTH = 4
local TAB_WIDTH_WEB = 2
vim.opt.tabstop = TAB_WIDTH
vim.opt.softtabstop = TAB_WIDTH
vim.bo.shiftwidth = TAB_WIDTH
vim.opt.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = function()
		vim.bo.shiftwidth = TAB_WIDTH_WEB
		vim.bo.tabstop = TAB_WIDTH_WEB
		vim.bo.softtabstop = TAB_WIDTH_WEB
		vim.bo.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "odin", "zig", "rust" },
	callback = function()
		vim.bo.tabstop = TAB_WIDTH
		vim.bo.softtabstop = TAB_WIDTH
		vim.bo.shiftwidth = TAB_WIDTH
		vim.bo.expandtab = true
	end,
})

vim.opt.wrap = false
vim.wo.wrap = false

vim.opt.hlsearch = true
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")

-- Change terminal mode exit
vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "exit terminal mode" })

-- user ctrl+hjkl to move splits
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down half page and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up half page and center" })
vim.keymap.set("n", "<S-g>", "<S-g>zz", { desc = "Move to bottom and center view" })

-- move around buffers
vim.api.nvim_set_keymap("n", "<leader>bd", ":bp|bd #<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bp", ":bp<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>bn", ":bn<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "format current buffer" })

vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = false,
})

-- remove background colours and use terminal bg
vim.cmd.hi("Comment gui=none")
vim.cmd.hi("Normal guibg=none")
vim.cmd.hi("NormalNC guibg=none")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "tpope/vim-sleuth" },
	{ "lewis6991/gitsigns.nvim" },
	{
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			preset = "modern",
		},
		config = function() -- This is the function that runs, AFTER loading
			require("which-key").setup()

			-- Document existing key chains
			require("which-key").add({
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
				{ "<leader>b", group = "[B]uffer" },
			})
		end,
	},
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				build = "make",

				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "echasnovski/mini.icons" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		config = function()
			-- [[ Configure telescope ]]
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						".bundle.js",
						".map",
					},
				},
			})

			-- enable telescope extensions
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
	-- LSP time
	{
		"neovim/nvim-lspconfig",
		dependencies = (function()
			local deps = {"saghen/blink.cmp"}
			if vim.fn.has("win32") == 1 then
				vim.list_extend(deps, {
					{ "mason-org/mason.nvim", opts = {} },
					"mason-org/mason-lspconfig.nvim",
					"WhoIsSethDaniel/mason-tool-installer.nvim",
				})
			end
			return deps
		end)(),
		config = function()
			local is_windows = vim.fn.has("win32") == 1
			-- attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementations")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")
					map("K", vim.lsp.buf.hover, "Hover documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							diagnosits = {
								globals = { "vim" },
							},
						},
					},
				},
				eslint = {
					quiet = true,
				},
				ts_ls = {},
				rust_analyzer = {},
				ols = {},
				clangd = {
					cmd = {
						"clangd",
						"--clang-tidy",
						"-j=5",
						"--malloc-trim",
					},
					filetypes = { "c" }, -- "cpp"
				},
			}
			if is_windows then
				require("mason").setup()

				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua", -- Used to format Lua code
					"typescript-language-server",
					"zls",
					"rust-analyzer",
					"stylua",
					"eslint-lsp",
					"prettier",
					"clangd",
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

				require("mason-lspconfig").setup({
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							-- This handles overriding only values explicitly passed
							-- by the server configuration above. Useful when disabling
							-- certain features of an LSP (for example, turning off formatting for tsserver)
							server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			else
				for server_name, server_config in pairs(servers) do
					server_config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
					require("lspconfig")[server_name].setup(server_config)
				end
			end
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 5000,
						lsp_fallback = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javescriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- TODO: make snippets
				},
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "super-tab",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },

			-- TODO: figure out how to automate building the rust fzf matcher
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
	{
		"thesimonho/kanagawa-paper.nvim",
		priority = 1000,
		init = function()
			-- load
			vim.cmd.colorscheme("kanagawa-paper")
		end,
	},
	{

		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.notify").setup({ lsp_progress = { enable = true } })
			require("mini.icons").setup()

			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
	{ -- this is poggers
		"stevearc/oil.nvim",
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			require("oil").setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = true,
				},
			})

			-- Open parent dir in current window
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

			-- Open parent dir in floating window
			vim.keymap.set("n", "<space>-", require("oil").toggle_float)
		end,
	},
	{ -- show lsp issues in window
		"folke/trouble.nvim",
		opts = {
			auto_preview = false,
		},
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},
	{
		"zbirenbaum/copilot.lua",
		enabled = function()
			return vim.loop.os_uname().sysname == "Windows_NT"
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		enabled = function()
			return vim.loop.os_uname().sysname == "Windows_NT"
		end,
		opts = {},
		config = function()
			require("codecompanion").setup({
				strategies = {
					chat = { adapters = "copilot" },
					inline = { adapters = "copilot" },
					cmd = { adapters = "copilot" },
				},
			})

			vim.keymap.set("n", "<leader>bv", ":CodeCompanionChat Toggle<CR>", { noremap = true, silent = true })
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
	},
})
