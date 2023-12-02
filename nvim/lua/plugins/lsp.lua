return {
	-- json
	{
		"b0o/schemastore.nvim",
	},

	{
		"williamboman/mason.nvim",
		config = true,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = { automatic_installation = true },
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			--- diagnostics settings
			local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }

			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

			vim.diagnostic.config({
				virtual_text = false,
				severity_sort = true,
				float = {
					-- from nvim_open_win()
					focusable = false,
					border = "rounded",
					-- from vim.diagnostic.open_float()
					header = "", -- default: Diagnostics
					source = "always", -- show source if truthy
					prefix = "", -- default: list number
				},
			})

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- formatting on save
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			local on_attach = function(client, bufnr)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
				end, bufopts)
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local nvim_lsp = require("lspconfig")
			require("mason-lspconfig").setup_handlers({
				function(server_name) -- default handler (optional)
					nvim_lsp[server_name].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					nvim_lsp.lua_ls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							Lua = {
								diagnostics = {
									-- Get the language server to recognize the `vim` global
									globals = { "vim" },
								},
							},
						},
					})
				end,
				["jsonls"] = function()
					nvim_lsp.jsonls.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,
				["intelephense"] = function()
					nvim_lsp.intelephense.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						init_options = {
							storagePath = "/tmp/intelephense",
							licenceKey = "TTYS3",
						},
						settings = {
							intelephense = {
								files = {
									-- Maximum file size in bytes
									maxSize = 5000000,
								},
							},
						},
					})
				end,
				["tailwindcss"] = function()
					nvim_lsp.tailwindcss.setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = {
							tailwindCSS = {
								experimental = {
									classRegex = {
										{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
									},
								},
							},
						},
					})
				end,
			})
		end,
	},

	-- linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- formatting
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					python = { "isort", "black" },
				},
				format_on_save = function(bufnr)
					-- Disable autoformat on certain filetypes
					local ignore_filetypes = { "php", "sql", "java" }
					if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
						return
					end
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					-- Disable autoformat for files in a certain path
					local bufname = vim.api.nvim_buf_get_name(bufnr)
					if bufname:match("/node_modules/") then
						return
					end
					return { lsp_fallback = true }
				end,
			})

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
	},
}
