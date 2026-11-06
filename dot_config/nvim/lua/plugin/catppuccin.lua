-- catppuccin: カラースキーム。hunk・bat・delta と同じ Mocha にして、見た目を揃える。
-- https://github.com/catppuccin/nvim

vim.pack.add({ { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } })

require('catppuccin').setup({
  flavour = 'mocha',         -- 4 種類（latte・frappe・macchiato・mocha）のうち一番暗いもの
  auto_integrations = true,  -- vim.pack で入れたプラグイン（which-key など）を見つけて、その配色も合わせる
})

vim.cmd.colorscheme('catppuccin')
