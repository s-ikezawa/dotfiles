// Kotlin LSP の動作確認用。このファイルを nvim で開くと kotlin_lsp が起動する
// （設定は ~/.config/nvim/lsp/kotlin_lsp.lua、サーバの実体は mise の [tools] の
// http:kotlin-lsp）。初回はインデックスを作るので、診断が出るまで数十秒かかる。
//
// 起動したかどうかは :checkhealth vim.lsp で見る（Active Clients に kotlin_lsp が出る）。
// 出ない・すぐ落ちるときは :lua vim.cmd.edit(vim.lsp.get_log_path()) でログを開く。
// "This build of intellij-server has expired." が出ていたらビルドの期限切れなので、
// ~/.config/mise/config.toml の http:kotlin-lsp のバージョンを上げる（経緯はそちらのコメントに）。
//
// 試せること:
//   診断        下の mismatched の行に型の不一致が出る。42 を "42" に直すと消える
//   hover       識別子の上で K
//   補完        挿入モードで CTRL-X CTRL-O（自動では出ないので自分で引く）
//   定義へ移動  greet の呼び出しの上で CTRL-] 、戻るのは CTRL-T
//   参照 / 名前  grr で参照一覧、grn でリネーム、gra でコードアクション
//   診断の移動  ]d / [d 、一覧は :lua vim.diagnostic.setqflist()

fun greet(name: String): String = "Hello, $name!"

fun main() {
    // 型が合わないので診断が出る
    val mismatched: String = 42

    println(greet("Kotlin"))
    println(mismatched)
}
