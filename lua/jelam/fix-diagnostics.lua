-- Temporary fix for duplicate diagnostics
-- Add this to your init.lua temporarily to debug

local original_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]

vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  -- Get the client
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  
  -- Only process if client exists and is rust-analyzer
  if client and client.name == "rust-analyzer" then
    -- Clear any existing diagnostics for this buffer from this namespace first
    local bufnr = vim.uri_to_bufnr(result.uri)
    vim.diagnostic.reset(vim.lsp.diagnostic.get_namespace(ctx.client_id), bufnr)
  end
  
  -- Call the original handler
  return original_handler(err, result, ctx, config)
end

-- Also ensure diagnostics are deduplicated on display
local original_get = vim.diagnostic.get
vim.diagnostic.get = function(bufnr, opts)
  local diagnostics = original_get(bufnr, opts)
  
  -- Deduplicate by line, column, and message
  local seen = {}
  local unique = {}
  
  for _, diag in ipairs(diagnostics) do
    local key = string.format("%d:%d:%s", diag.lnum, diag.col, diag.message)
    if not seen[key] then
      seen[key] = true
      table.insert(unique, diag)
    end
  end
  
  return unique
end

print("Diagnostic deduplication loaded. Restart LSP with :LspRestart")
