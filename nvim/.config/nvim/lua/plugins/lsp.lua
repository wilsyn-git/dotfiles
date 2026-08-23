-- LSP: mason (installer) + mason-lspconfig (bridge) + nvim-lspconfig (configs).
-- Uses the Neovim 0.11+ API: vim.lsp.config / vim.lsp.enable, with
-- mason-lspconfig's automatic_enable (default) wiring installed servers up.
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    require("mason").setup()

    -- LSP-aware completion capabilities from blink.cmp, applied to every server.
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- lua_ls: teach it about the Neovim runtime + the `vim` global.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    -- R: `languageserver` is a CRAN package, not a standalone binary, so it is
    -- installed into the user R library (install.packages("languageserver"))
    -- rather than through mason -- lspconfig launches it as `R -e
    -- languageserver::run()` straight off $PATH. It covers completion, hover,
    -- go-to-definition and lintr diagnostics for r/rmd/quarto buffers.
    --
    -- Formatting is deliberately handed to `air` (below): both servers advertise
    -- documentFormattingProvider, and two formatting-capable clients on one
    -- buffer makes vim.lsp.buf.format() stop and ask which to use every time.
    vim.lsp.config("r_language_server", {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })
    vim.lsp.enable("r_language_server")

    require("mason-lspconfig").setup({
      -- air: Posit's R formatter/language server (a Rust binary, so mason can
      -- own it). Registers for `r` filetypes only and is the sole formatter
      -- there; automatic_enable picks it up once installed.
      -- yamlls: completion/validation for the YAML front matter at the top of
      -- .qmd and .Rmd documents (R.nvim's :checkhealth asks for it by name).
      ensure_installed = { "lua_ls", "air", "yamlls" },
      -- automatic_enable (default true) enables every installed server that
      -- nvim-lspconfig ships an lsp/ config for. Exclude stylua: it is a
      -- formatter, not a language server, so enabling it as one just makes it
      -- start and immediately quit with exit code 2 on every Lua buffer.
      automatic_enable = {
        exclude = { "stylua" },
      },
    })

    -- Buffer-local LSP keymaps, wired on attach.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
      callback = function(ev)
        local opts = function(desc)
          return { buffer = ev.buf, desc = desc }
        end
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Goto definition"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Goto references"))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))
        vim.keymap.set({ "n", "v" }, "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, opts("Format"))
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, opts("Previous diagnostic"))
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, opts("Next diagnostic"))
      end,
    })
  end,
}
