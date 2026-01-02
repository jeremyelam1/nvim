return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  ft = { "rust" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  init = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.g.rustaceanvim = {
      server = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.server_capabilities.semanticTokensProvider = nil
          client.server_capabilities.inlayHintProvider = nil
          vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
              update_in_insert = false,
            }
          )
        end,
        default_settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              enable = true,
              command = "clippy",
              extraArgs = { "--all-targets", "--", "-A", "unused_variables" },
            },
            check = {
              enable = false,
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            procMacro = {
              enable = true,
              attributes = {
                enable = true,
              },
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            diagnostics = {
              enable = true,
              disabled = { "unresolved-proc-macro", "inactive-code" },
              experimental = {
                enable = false,
              },
            },
            completion = {
              callable = {
                snippets = "fill_arguments",
              },
            },
            inlayHints = {
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = "never",
              },
              lifetimeElisionHints = {
                enable = "never",
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "never",
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      },
      dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(
          vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/lldb/lib/liblldb.so"
        ),
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rust",
      callback = function()
        local opts = { buffer = true, silent = true }

        vim.keymap.set(
          "n",
          "<leader>rr",
          "<cmd>RustLsp runnables<CR>",
          vim.tbl_extend("force", opts, { desc = "Rust runnables" })
        )
        vim.keymap.set(
          "n",
          "<leader>rd",
          "<cmd>RustLsp debuggables<CR>",
          vim.tbl_extend("force", opts, { desc = "Rust debuggables" })
        )
        vim.keymap.set(
          "n",
          "<leader>rt",
          "<cmd>RustLsp testables<CR>",
          vim.tbl_extend("force", opts, { desc = "Rust testables" })
        )
        vim.keymap.set(
          "n",
          "<leader>re",
          "<cmd>RustLsp expandMacro<CR>",
          vim.tbl_extend("force", opts, { desc = "Expand macro" })
        )
        vim.keymap.set(
          "n",
          "<leader>rc",
          "<cmd>RustLsp openCargo<CR>",
          vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" })
        )
        vim.keymap.set(
          "n",
          "<leader>rp",
          "<cmd>RustLsp parentModule<CR>",
          vim.tbl_extend("force", opts, { desc = "Go to parent module" })
        )
        vim.keymap.set(
          "n",
          "<leader>rj",
          "<cmd>RustLsp joinLines<CR>",
          vim.tbl_extend("force", opts, { desc = "Join lines" })
        )
        vim.keymap.set(
          "n",
          "<leader>rh",
          "<cmd>RustLsp hover actions<CR>",
          vim.tbl_extend("force", opts, { desc = "Hover actions" })
        )
        vim.keymap.set(
          "n",
          "<leader>rm",
          "<cmd>RustLsp rebuildProcMacros<CR>",
          vim.tbl_extend("force", opts, { desc = "Rebuild proc macros" })
        )
        vim.keymap.set(
          "n",
          "<leader>rv",
          "<cmd>RustLsp crateGraph<CR>",
          vim.tbl_extend("force", opts, { desc = "View crate graph" })
        )
      end,
    })
  end,
}
