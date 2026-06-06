local is_windows = vim.fn.has("win32") == 1

do
	vim.loader.enable()

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	vim.g.have_nerd_font = true

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
		update_in_insert = false,
		severity_sort = true,
		float = { border = "rounded", source = "if_many" },
		underline = { severity = { min = vim.diagnostic.severity.WARN } },

		virtual_text = true,
		virtual_lines = false,

		jump = {
			on_jump = function(_, bufnr)
				vim.diagnostic.open_float({
					bufnr = bufnr,
					scope = "cursor",
					focue = false,
				})
			end,
		},
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
end

-- Switch to vim.pack
do
	local function run_build(name, cmd, cwd)
		local result = vim.system(cmd, { cwd = cwd }):wait()
		if result.code ~= 0 then
			local stderr = result.stderr or ""
			local stdout = result.stdout or ""
			local output = stderr ~= "" and stderr or stdout
			if output == "" then
				output = "No output from build command."
			end
			vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
		end
	end

	vim.api.nvim_create_autocmd("PackChanged", {
		callback = function(ev)
			local name = ev.data.spec.name
			local kind = ev.data.kind
			if kind ~= "install" and kind ~= "update" then
				return
			end

			if name == "telescope-fzf-native.nvim" and vim.fn.executable("make") == 1 then
				run_build(name, { "make" }, ev.data.path)
				return
			end

			if name == "LuaSnip" then
				if vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
					run_build(name, { "make", "install_jsregexp" }, ev.data.path)
				end
				return
			end

			if name == "nvim-treesitter" then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				vim.cmd("TSUpdate")
				return
			end
		end,
	})
end

--@param repo string
--@return string
local function gh(repo)
	return "https://github.com/" .. repo
end

-- Basics
do
	vim.pack.add({ gh("tpope/vim-sleuth") })

	vim.pack.add({ gh("NMAC427/guess-indent.nvim") })
	require("guess-indent").setup({})

	vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
	require("gitsigns").setup({
		signs = {
			add = { text = "+" }, ---@diagnostic disable-line: missing-fields
			change = { text = "~" }, ---@diagnostic disable-line: missing-fields
			delete = { text = "_" }, ---@diagnostic disable-line: missing-fields
			topdelete = { text = "‾" }, ---@diagnostic disable-line: missing-fields
			changedelete = { text = "~" }, ---@diagnostic disable-line: missing-fields
		},
	})

	vim.pack.add({ gh("folke/which-key.nvim") })
	require("which-key").setup({
		delay = 0,
		icons = { mappings = vim.g.have_nerd_font },
		spec = {
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			{ "<leader>b", group = "[B]uffer" },
		},
	})

	vim.pack.add({ gh("thesimonho/kanagawa-paper.nvim") })
	require("kanagawa-paper").setup({})
	vim.cmd.colorscheme("kanagawa-paper")

	vim.pack.add({ gh("folke/todo-comments.nvim") })
	require("todo-comments").setup({ signs = false })

	vim.pack.add({ gh("lukas-reineke/indent-blankline.nvim") })
	require("ibl").setup()

	vim.pack.add({ gh("MeanderingProgrammer/render-markdown.nvim") })
	require("render-markdown").setup({
		ft = { "markdown", "codecompanion" },
	})

	vim.pack.add({ gh("brenoprata10/nvim-highlight-colors") })
	require("nvim-highlight-colors").setup()

	vim.pack.add({ gh("nvim-mini/mini.nvim") })
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
end

-- Telescope and Oil
do
	--@type (string|vim.pack.Spec)[]
	local telescope_plugins = {
		gh("nvim-lua/plenary.nvim"),
		gh("nvim-telescope/telescope.nvim"),
		gh("nvim-telescope/telescope-ui-select.nvim"),
	}
	if vim.fn.executable("make") == 1 then
		table.insert(telescope_plugins, gh("nvim-telescope/telescope-fzf-native.nvim"))
	end

	vim.pack.add(telescope_plugins)

	require("telescope").setup({
		defaults = {
			file_ignore_patterns = {
				"node_modules",
				".bundle.js",
				".map",
			},
		},
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown(),
			},
		},
	})
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
	vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
	vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
		callback = function(event)
			local buf = event.buf
			vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
			vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })
			vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
			vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })
			vim.keymap.set(
				"n",
				"gW",
				builtin.lsp_dynamic_workspace_symbols,
				{ buffer = buf, desc = "Open Workspace Symbols" }
			)
			vim.keymap.set(
				"n",
				"grt",
				builtin.lsp_type_definitions,
				{ buffer = buf, desc = "[G]oto [T]ype Definition" }
			)
		end,
	})

	vim.keymap.set("n", "<leader>/", function()
		builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in the current buffer" })

	vim.keymap.set("n", "<leader>s/", function()
		builtin.live_grep({
			grep_open_files = true,
			prompt_title = "Live Grep in Open Files",
		})
	end, { desc = "[S]earch [/] in Open Files" })

	-- Shortcut for searching your Neovim configuration files
	vim.keymap.set("n", "<leader>sn", function()
		builtin.find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [N]eovim files" })

	vim.pack.add({ gh("stevearc/oil.nvim") })
	require("oil").setup({ -- this is poggers
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
end

-- LSP
do
	vim.pack.add({ gh("j-hui/fidget.nvim") })
	require("fidget").setup({})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("config-lsp-attach", { clear = true }),
		callback = function(event)
			local map = function(keys, func, desc, mode)
				mode = mode or "n"
				vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
			end

			map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
			map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
			map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

			-- The following two autocommands are used to highlight references of the
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client:supports_method("textDocument/documentHighlight", event.buf) then
				local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
					end,
				})
			end
		end,
	})

	-- enable following lsp's
	--@type table<string, vim.lsp.Config>
	local shared_servers = {
		stylua = {}, -- Used to format Lua code

		-- Special Lua Config, as recommended by neovim help docs
		lua_ls = {
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						version = "LuaJIT",
						path = { "lua/?.lua", "lua/?/init.lua" },
					},
					workspace = {
						checkThirdParty = false,
						-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
						--  See https://github.com/neovim/nvim-lspconfig/issues/3189
						library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
							"${3rd}/luv/library",
							"${3rd}/busted/library",
						}),
					},
				})
			end,
			---@type lspconfig.settings.lua_ls
			settings = {
				Lua = {
					format = { enable = false }, -- Disable formatting (formatting is done by stylua)
				},
			},
		},
		eslint = {
			quiet = true,
			settings = {
				useFlatConfig = true,
				experimental = {
					useFlatConfig = true,
				},
			},
		},
		ts_ls = {},
	}
	--@type table<string, vim.lsp.Config>
	local work_servers = {}
	--@type table<string, vim.lsp.Config>
	local linux_servers = {
		clangd = {},
		rust_analyzer = {},
		zls = {},
	}

	--@type table<string, vim.lsp.Config>
	local servers = vim.tbl_deep_extend("force", shared_servers, is_windows and work_servers or linux_servers)

	vim.pack.add({
		gh("neovim/nvim-lspconfig"),
		gh("mason-org/mason.nvim"),
		gh("mason-org/mason-lspconfig.nvim"),
		gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
	})

	-- Automatically install LSPs and related tools to stdpath for Neovim
	require("mason").setup({})

	-- Ensure the servers and tools above are installed
	-- You can press `g?` for help in this menu.
	local ensure_installed = vim.tbl_keys(servers or {})
	vim.list_extend(ensure_installed, {
		-- You can add other tools here that you want Mason to install
	})

	require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

	for name, server in pairs(servers) do
		vim.lsp.config(name, server)
		vim.lsp.enable(name)
	end

	-- LSP diagnostics window
	vim.pack.add({ gh("folke/trouble.nvim") })
	require("trouble").setup({
		auto_preview = false,
		cmd = "Trouble",
	})

	vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
	vim.keymap.set(
		"n",
		"<leader>xX",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		{ desc = "Buffer Diagnostics (Trouble)" }
	)
	vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
	vim.keymap.set(
		"n",
		"<leader>cl",
		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		{ desc = "LSP Definitions / references / ... (Trouble)" }
	)
	vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
	vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
end

-- Formatting
do
	vim.pack.add({ gh("stevearc/conform.nvim") })
	require("conform").setup({
		notify_on_error = false,
		format_on_save = function(bufnr)
			local enabled_filetypes = {
				lua = true,
				javascript = true,
				javascriptreact = true,
				typescript = true,
				typescriptreact = true,
				html = true,
				css = true,
				markdown = true,
			}
			if enabled_filetypes[vim.bo[bufnr].filetype] then
				return { timeout_ms = 500 }
			else
				return nil
			end
		end,
		default_format_opts = {
			lsp_format = "fallback", -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
		},
		-- You can also specify external formatters in here.
		formatters_by_ft = {
			rust = { "rustfmt" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
		},

		vim.keymap.set({ "n", "v" }, "<leader>f", function()
			require("conform").format({ async = true })
		end, { desc = "[F]ormat buffer" }),
	})
end

-- Autocomplete and snippets
do
	vim.pack.add({ { src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2.*") } })
	require("luasnip").setup({})
	vim.pack.add({ { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") } })
	require("blink.cmp").setup({
		keymap = {
			preset = "super-tab",
			-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
			--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
		},
		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			-- By default, you may press `<c-space>` to show the documentation.
			-- Optionally, set `auto_show = true` to show the documentation after a delay.
			documentation = { auto_show = true, auto_show_delay_ms = 500 },
		},

		sources = {
			default = { "lsp", "path", "snippets" },
		},

		snippets = { preset = "luasnip" },

		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	})

	vim.pack.add({ gh("folke/lazydev.nvim") })
end

-- linux only
do
	if not is_windows then
		vim.pack.add({
			{
				src = gh("JavaHello/spring-boot.nvim"),
				version = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
			},
			gh("MunifTanjim/nui.nvim"),
			gh("mfussenegger/nvim-dap"),

			gh("nvim-java/nvim-java"),
		})

		require("java").setup()
		vim.lsp.enable("jdtls")
	end
end

-- windows only
do
	if is_windows then
		vim.pack.add({ gh("zbirenbaum/copilot.lua") })
		vim.pack.add({ gh("olimorris/codecompanion.nvim") })
		require("codecompanion").setup({

			strategies = {
				chat = { adapters = "copilot" },
				inline = { adapters = "copilot" },
				cmd = { adapters = "copilot" },
			},
		})

		vim.keymap.set("n", "<leader>bv", ":CodeCompanionChat Toggle<CR>", { noremap = true, silent = true })
	end
end
