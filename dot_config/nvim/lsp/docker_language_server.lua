-- Docker 公式の言語サーバー（docker-language-server。mise で github:docker/docker-language-server として導入）の設定。
-- Dockerfile と compose のファイルで、補完・ホバー・定義へのジャンプ・診断（BuildKit のチェックなど）を出す。
-- compose のファイルは Neovim の既定では yaml になり Dockerfile と区別できないので、
-- lua/config/options.lua で yaml.docker-compose にしている（YAML の ftplugin とハイライトはそのまま効く）。
-- Dockerfile のリンターの hadolint は言語サーバーではないので、別に lua/config/hadolint.lua で走らせる。

---@type vim.lsp.Config
return {
  cmd = { 'docker-language-server', 'start', '--stdio' }, -- 起動するコマンド
  filetypes = { 'dockerfile', 'yaml.docker-compose' },    -- このファイルタイプのバッファで動かす
  -- サーバーはファイルの種類を languageId で見分ける。Neovim は既定でファイルタイプをそのまま送るので、
  -- サーバーの決めた名前（dockerfile・dockercompose）に直す
  get_language_id = function(_, filetype)
    return filetype == 'yaml.docker-compose' and 'dockercompose' or filetype
  end,
  -- 上の階層へ探して、最初に見つかった場所をプロジェクトのルートにする
  root_markers = { '.git', 'compose.yaml', 'compose.yml', 'docker-compose.yaml', 'docker-compose.yml', 'Dockerfile' },
}
