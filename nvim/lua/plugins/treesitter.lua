local ensure_installed = {
  "json",
  "yaml",
  "css",
  "html",
  "javascript",
  "typescript",
  "tsx",
  "bash",
  "vim",
  "vimdoc",
  "lua",
  "python",
}

return {
  {
    -- NOTE: treesitter CLI installation needed
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function() require("nvim-treesitter").install(ensure_installed):wait(300000) end,
    branch = "main",
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then return end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"

        -- check if treesitter indentation is available for this language, and if so enable it
        -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
        local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

        -- enables treesitter based indentation
        if has_indent_query then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-attach", { clear = true }),
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end

          treesitter_try_attach(buf, language)
        end,
      })
    end,
  },

  -- NOTE: js,ts,jsx,tsx Auto Close Tags
  {
    "windwp/nvim-ts-autotag",
    enabled = true,
    ft = { "html", "xml", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
    config = function()
      -- Independent nvim-ts-autotag setup
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true, -- Auto-close tags
          enable_rename = true, -- Auto-rename pairs
          enable_close_on_slash = false, -- Disable auto-close on trailing `</`
        },
      })
    end,
  },
}
