local function code_action_sync(client, bufnr, cmd)
  local params = vim.lsp.util.make_range_params(
    0,
    client.offset_encoding
  )
  params.context = { only = { cmd }, diagnostics = {} }

  local res = client:request_sync('textDocument/codeAction', params, 3000, bufnr)
  for cid, r in pairs(res and res.result or {}) do
    if r.edit then
      local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
      vim.lsp.util.apply_workspace_edit(r.edit, enc)
    end
  end
end

local function organize_imports_sync(client, bufnr)
  code_action_sync(client, bufnr, 'source.organizeImports')
end

local function format_sync(client, bufnr)
  vim.lsp.buf.format({
    async = false,
    -- bufnr = bufnr,
    --filter = function()
    --  return client.name ~= 'ts_ls'
    --end
  })
end

local function fix_all_sync(client, bufnr)
  code_action_sync(client, bufnr, 'source.fixAll')
end

local save_handlers_by_client_name = {
  gopls = {
    organize_imports_sync,
    format_sync
  },
  biome = {
    fix_all_sync,
    organize_imports_sync,
    format_sync
  }
}

vim.lsp.enable({
  -- Go
  'gopls',
  -- Lua
  'lua_ls',
  -- TypeScript
  'ts_ls',
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        local bufnr = args.buf
        local shouldSleep = false
        for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
          local save_handlers = save_handlers_by_client_name[client.name]
          for _, f in pairs(save_handlers or {}) do
            if shouldSleep then
              vim.api.nvim_command('sleep 10ms')
            else
              shouldSleep = true
            end
            f(client, bufnr)
          end
        end
      end
    })
  end
})

