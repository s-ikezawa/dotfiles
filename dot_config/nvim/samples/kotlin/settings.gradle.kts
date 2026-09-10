// ~/.config/nvim/lsp/kotlin_lsp.lua の root_markers に挙げてあるファイルの 1 つ。
// これが置いてあるディレクトリがワークスペースのルートになる。
// 隣の build.gradle.kts もマーカーなので片方だけ消してもルートは変わらないが、
// 両方消すと workspace_required = true により LSP がそもそも起動しない。
rootProject.name = "kotlin-lsp-sample"
