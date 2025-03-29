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
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        },
      })

      local opts = { noremap = true, silent = true }
      -- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
      -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

      vim.diagnostic.config({
        virtual_text = { current_line = true },
        severity_sort = true,
        float = {
          -- from nvim_open_win()
          focusable = true,
          border = "rounded",
          -- from vim.diagnostic.open_float()
          header = "",       -- default: Diagnostics
          source = "always", -- show source if truthy
          prefix = "",       -- default: list number
        },
      })

      -- To instead override globally
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      ---@diagnostic disable-next-line: duplicate-set-field
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or 'rounded'
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      local on_attach = function(_, bufnr)
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        -- vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "grd", vim.lsp.buf.type_definition, bufopts)
        -- vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        -- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        -- vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
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
        ["angularls"] = function()
          local ok, mason_registry = pcall(require, 'mason-registry')
          if not ok then
            vim.notify('mason-registry could not be loaded')
            return
          end

          local angularls_path = mason_registry.get_package('angular-language-server'):get_install_path()

          local function get_angular_version()
            local package_json_path = vim.fn.getcwd() .. '/package.json'
            local default_version = '19.1.6' -- Set default version

            -- Check if package.json exists
            if vim.fn.filereadable(package_json_path) == 0 then
              return default_version
            end

            local package_json_content = vim.fn.readfile(package_json_path)
            if package_json_content then
              local package_json = vim.fn.json_decode(table.concat(package_json_content))
              -- Check @angular/core version in dependencies
              if package_json and package_json.dependencies and package_json.dependencies["@angular/core"] then
                -- Remove ^ or ~ from version string
                local version = string.gsub(package_json.dependencies["@angular/core"], "^[~^]", "")
                return version
              end
            end

            return default_version
          end

          --tsProbeLocations: Path of typescript. Required.
          --ngProbeLocations: Path of @angular/language-service. Required.
          --forceStrictTemplates: Forces the language service to use strictTemplates and ignore the user settings in the 'tsconfig.json'.
          --includeAutomaticOptionalChainCompletions: Shows completions on potentially undefined values that insert an optional chain call. Requires TS 3.7+ and strict null checks to be enabled.
          --includeCompletionsWithSnippetText: Enables snippet completions from Angular language server;
          local cmd = {
            'ngserver',
            '--stdio',
            '--tsProbeLocations',
            angularls_path .. ',' .. vim.fn.getcwd(),
            '--ngProbeLocations',
            angularls_path .. '/node_modules/@angular/language-server',
            '--forceStrictTemplates',
            '--includeAutomaticOptionalChainCompletions',
            '--includeCompletionsWithSnippetText',
            '--angularCoreVersion',
            get_angular_version(),
            -- '--logFile',
            -- vim.fn.getcwd() .. '/Angular-Language-Service.log',
            -- '--logVerbosity',
            -- 'verbose',
          }

          nvim_lsp.angularls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = cmd,
            on_new_config = function(new_config, new_root_dir)
              new_config.cmd = cmd
            end,
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
            settings = {
              pyright = {
                -- Using Ruff's import organizer
                disableOrganizeImports = true,
              },
              python = {
                analysis = {
                  -- Ignore all files for analysis to exclusively use Ruff for linting
                  ignore = { '*' },
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
}
