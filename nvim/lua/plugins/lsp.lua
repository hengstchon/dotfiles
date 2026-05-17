-- LSP Plugins
return {
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "mason-org/mason.nvim",
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
      },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          automatic_enable = false,
        },
      },
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = { notification = { window = { avoid = { "NvimTree" } } } } },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.o.winborder = "rounded"

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local InstallLocation = require("mason-core.installer.InstallLocation")
      local mason_registry = require("mason-registry")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
          map("grd", vim.lsp.buf.type_definition, "[G]oto Type [D]efinition")
          map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
          map("grr", vim.lsp.buf.references, "[G]oto [R]eferences")
          map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
          map("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
          map(
            "<leader>wl",
            function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            "[W]orkspace [L]ist Folders"
          )

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

          if client and client:supports_method("textDocument/inlayHint", event.buf) then
            map(
              "<leader>th",
              function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })) end,
              "[T]oggle Inlay [H]ints"
            )
          end
        end,
      })

      local function get_angular_version()
        local package_json_path = vim.fn.getcwd() .. "/package.json"
        local default_version = "19.1.6"

        if vim.fn.filereadable(package_json_path) == 0 then return default_version end

        local package_json_content = vim.fn.readfile(package_json_path)
        if package_json_content then
          local package_json = vim.fn.json_decode(table.concat(package_json_content))
          if package_json and package_json.dependencies and package_json.dependencies["@angular/core"] then
            return string.gsub(package_json.dependencies["@angular/core"], "^[~^]", "")
          end
        end

        return default_version
      end

      local function get_python_path(workspace)
        if vim.env.VIRTUAL_ENV then return vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python") end

        for _, pattern in ipairs({ "*", ".*" }) do
          local matches = vim.fn.glob(vim.fs.joinpath(workspace, pattern, "pyvenv.cfg"), false, true)
          if #matches > 0 then return vim.fs.joinpath(vim.fs.dirname(matches[1]), "bin", "python") end
        end

        return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3")
          or vim.fn.exepath("python") ~= "" and vim.fn.exepath("python")
          or "python"
      end

      local function get_angularls_cmd()
        local angularls_pkg = mason_registry.get_package("angular-language-server")
        local angularls_path = InstallLocation.global():package(angularls_pkg.name)
        return {
          "ngserver",
          "--stdio",
          "--tsProbeLocations",
          angularls_path .. "," .. vim.fn.getcwd(),
          "--ngProbeLocations",
          angularls_path .. "/node_modules/@angular/language-server",
          "--forceStrictTemplates",
          "--includeAutomaticOptionalChainCompletions",
          "--includeCompletionsWithSnippetText",
          "--angularCoreVersion",
          get_angular_version(),
        }
      end

      ---@type table<string, vim.lsp.Config>
      local servers = {
        stylua = {},
        ts_ls = {},
        angularls = {
          cmd = get_angularls_cmd(),
          on_new_config = function(new_config) new_config.cmd = get_angularls_cmd() end,
        },
        pyright = {
          before_init = function(_, config)
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            config.settings.python.pythonPath = get_python_path(config.root_dir)
          end,
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                ignore = { "*" },
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        intelephense = {
          init_options = {
            storagePath = "/tmp/intelephense",
            licenceKey = "TTYS3",
          },
          settings = {
            intelephense = {
              files = {
                maxSize = 5000000,
              },
            },
          },
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                },
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
          on_init = function(client)
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
                library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                }),
              },
            })
          end,
        },
      }

      local ensure_installed = {
        "angular-language-server",
        "intelephense",
        "json-lsp",
        "lua-language-server",
        "pyright",
        "stylua",
        "tailwindcss-language-server",
      }

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      vim.lsp.config("*", { capabilities = capabilities })
      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end

      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { current_line = true },
        underline = { severity = vim.diagnostic.severity.ERROR },
        float = {
          focusable = true,
          border = "rounded",
          header = "",
          source = "if_many",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
      })

      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { noremap = true, silent = true })
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
