return {
  "echasnovski/mini.ai",
  version = false,
  config = function()
    require('mini.ai').setup({
      custom_textobjects = {
        ['j'] = function()
          local ok, val = pcall(vim.fn.getchar)
          if not ok then return end
          local char = vim.fn.nr2char(val)

          local dict = {
            ['('] = { '（().-()）' },
            ['{'] = { '｛().-()｝' },
            ['['] = { '「().-()」' },
            [']'] = { '『().-()』' },
            ['<'] = { '＜().-()＞' },
            ['"'] = { '”().-()”' },
          }

          if char == 'b' then
          local ret = {}
          for _, v in pairs(dict) do table.insert(ret, v) end
            return { ret }
          end

          if dict[char] then return dict[char] end

          error('%s is unsupported textobjects in Japanese')
        end
      }
    })
  end
}
