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
          header = "",       -- default: Diagnostics
          source = "always", -- show source if truthy
          prefix = "",       -- default: list number
        },
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

      vim.lsp.handlers["textDocument/signatureHelp"] =
          vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      local on_attach = function(_, bufnr)
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
        ["pyright"] = function()
          -- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
          local util = require("lspconfig/util")
          local path = util.path

          local function get_python_path(workspace)
            -- Use activated virtualenv.
            if vim.env.VIRTUAL_ENV then
              return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
            end

            -- Find and use virtualenv in workspace directory.
            for _, pattern in ipairs({ "*", ".*" }) do
              local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
              if match ~= "" then
                return path.join(path.dirname(match), "bin", "python")
              end
            end

            -- Fallback to system Python.
            local exepath = vim.fn.exepath
            return exepath("python3") or exepath("python") or "python"
          end

          nvim_lsp.pyright.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            before_init = function(_, config)
              config.settings.python.pythonPath = get_python_path(config.root_dir)
            end,
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
}
