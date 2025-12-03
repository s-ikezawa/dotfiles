vim.lsp.enable({
  'lua_ls',
  -- Typescript
  'ts_ls',
  'biome',
})

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 2,
    source = 'if_many',
    prefix = "●",
    format = function(diagnostic)
      local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', ' ')
      return message
    end
  },
  virtual_lines = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

---@param client vim.lsp.Client
---@param bufnr integer
---@param cmd string
local function code_action_sync(client, bufnr, cmd)
  local enc = (vim.lsp.get_client_by_id(client.id) or {}).offset_encoding or "utf-16"
  -- https://github.com/golang/tools/blob/gopls/v0.11.0/gopls/doc/vim.md#imports
  local params = vim.lsp.util.make_range_params(nil, enc)
  params.context = { only = { cmd }, diagnostics = {} }
  -- gopls のドキュメントでは`vim.lsp.buf_request_sync` を使っているが、
  -- ここでは対象の Language Server を1つに絞るために `vim.lsp.Client` の `request_sync` を使う
  local res = client:request_sync('textDocument/codeAction', params, 3000, bufnr)
  for _, r in pairs(res and res.result or {}) do
    if r.edit then
      vim.lsp.util.apply_workspace_edit(r.edit, enc)
    end
  end
end

---@param client vim.lsp.Client
---@param bufnr integer
local function organize_imports_sync(client, bufnr)
  code_action_sync(client, bufnr, 'source.organizeImports')
end

---@param client vim.lsp.Client
---@param bufnr integer
local function fix_all_sync(client, bufnr)
  code_action_sync(client, bufnr, 'source.fixAll')
end

---@param client vim.lsp.Client
---@param bufnr integer
local function format_sync(client, bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(c)
      return c.id == client.id
    end,
    async = false,
  })
end

---@type table<string, fun(client: vim.lsp.Client, bufnr: integer)[]>
local save_handlers_by_client_name = {
  gopls = { organize_imports_sync, format_sync },
  biome = { fix_all_sync, organize_imports_sync, format_sync },
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    --=========================================================================
    -- Format On Save
    --=========================================================================
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        local shouldSleep = false
        for _, bclient in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
          local save_handlers = save_handlers_by_client_name[bclient.name]
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


