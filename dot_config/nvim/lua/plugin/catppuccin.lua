-- catppuccin: カラースキーム。hunk・bat・delta と同じ Mocha にして、見た目を揃える。
-- https://github.com/catppuccin/nvim

vim.pack.add({ { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } })

require('catppuccin').setup({
  flavour = 'mocha',         -- 4 種類（latte・frappe・macchiato・mocha）のうち一番暗いもの
  auto_integrations = true,  -- vim.pack で入れたプラグイン（which-key など）を見つけて、その配色も合わせる
})

vim.cmd.colorscheme('catppuccin')

-- catppuccin は配色をキャッシュし、setup() の設定が変わったときしか作り直さないので、
-- プラグインを入れたり消したりしても、そのプラグインの配色が入らない（または残る）。
-- vim.pack で入れたり消したりしたら、キャッシュの印（cached）を消して、次に起動したときに作り直させる。
-- catppuccin.lua はプラグインの設定の中で最初に読まれる（init.lua）ので、ほかのプラグインの vim.pack.add より先に登録できる。
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('config_catppuccin_recompile', { clear = true }),
  callback = function(ev)
    if ev.data.kind == 'install' or ev.data.kind == 'delete' then
      os.remove(require('catppuccin').options.compile_path .. '/cached')
    end
  end,
})
