-- ~/.config/nvim/lsp/kotlin_lsp.lua
-- ============================================================================
-- kotlin-lsp（JetBrains 公式）の LSP サーバ設定
-- ============================================================================
-- Neovim 0.11+ は runtimepath 上の lsp/<name>.lua を自動で
-- vim.lsp.config('<name>') として読み込む。起動（有効化）は lua/lsp.lua の
-- vim.lsp.enable('kotlin_lsp') が担う。
--
-- 実体は intellij-server バイナリで、`--stdio` で LSP を stdin/stdout に直接話す
-- （socat/netcat は不要）。brew formula(jetbrains/utils/kotlin-lsp) は PATH 上に
-- "kotlin-lsp" の名前で置くため、既定の cmd（intellij-server）ではなくこの名前を指定する。

---@type vim.lsp.Config
return {
  cmd = { "kotlin-lsp", "--stdio" },
  filetypes = { "kotlin" },
  root_markers = {
    "settings.gradle.kts", -- Gradle（マルチプロジェクトのルート）
    "settings.gradle",
    "build.gradle.kts",    -- Gradle
    "build.gradle",
    "pom.xml",             -- Maven
    "workspace.json",      -- 独自ビルドシステム連携用
  },

  -- ==========================================================================
  -- settings（workspace/configuration で動的に問い合わせられる設定）
  -- ==========================================================================
  -- kotlin-lsp は設定を initialize 時には読まず、起動後に workspace/configuration
  -- で "jetbrains.kotlin" セクションを問い合わせる。ここが空（=null 応答）だと
  -- inlay hints を一切生成しない（capability は宣言するのに {} を返す）。
  -- Neovim 0.11+ 既定の workspace/configuration ハンドラは、要求セクションを "." で
  -- 分割して settings 配下を tbl_get で返す。サーバ側は受け取ったツリーを再び "." で
  -- 平坦化して読むため、ネスト（type.function.return）と ["dotted.key"] のどちらでも
  -- 同じ平坦パスになり等価。よって settings.jetbrains.kotlin にネストで置けば
  -- カスタム handlers は不要。キー構造は VSCode 拡張（kotlin-vscode/package.json）準拠。
  --
  -- 各行のコメント末尾は VSCode 拡張での既定値。inlay hints の最終的な表示 ON/OFF は
  -- Snacks.toggle.inlay_hints（,uh）でバッファ単位に切り替える。
  settings = {
    jetbrains = {
      kotlin = {
        -- ---- inlay hints（VSCode 拡張の "Inlay" ブロック）-----------------
        hints = {
          -- パラメータ名ヒント（foo(name = ...) の name 部）
          parameters = true,              -- jetbrains.kotlin.hints.parameters         既定 true
          ["parameters.compiled"] = true, -- jetbrains.kotlin.hints.parameters.compiled 既定 true（ライブラリ等のコンパイル済みコード）
          ["parameters.excluded"] = false,-- jetbrains.kotlin.hints.parameters.excluded 既定 false（除外対象パラメータも表示）
          -- 型ヒント（settings.types.* / type.function.* / settings.lambda.* 配下）
          settings = {
            types = {
              property = true,  -- jetbrains.kotlin.hints.settings.types.property 既定 true（プロパティの型）
              variable = true,  -- jetbrains.kotlin.hints.settings.types.variable 既定 true（ローカル変数の型: val x = ... の : Int 等）
            },
            lambda = {
              ["return"] = true, -- jetbrains.kotlin.hints.settings.lambda.return 既定 true（ラムダ/return 式の型）
            },
            value = {
              ranges = true,     -- jetbrains.kotlin.hints.settings.value.ranges 既定 true（範囲式のヒント）
            },
          },
          type = {
            ["function"] = {
              ["return"] = true, -- jetbrains.kotlin.hints.type.function.return 既定 true（関数の戻り値型）
              parameter = true,  -- jetbrains.kotlin.hints.type.function.parameter 既定 true（関数宣言のパラメータ型）
            },
          },
          lambda = {
            receivers = {
              parameters = true, -- jetbrains.kotlin.hints.lambda.receivers.parameters 既定 true（暗黙のレシーバ/パラメータ）
            },
          },
          value = {
            kotlin = {
              time = true,       -- jetbrains.kotlin.hints.value.kotlin.time 既定 true（kotlin.time パッケージの警告ヒント）
            },
          },
          call = {
            chains = false,      -- jetbrains.kotlin.hints.call.chains 既定 false（呼び出しチェーンの戻り値型）
          },
        },
      },

      -- ---- ファイルテンプレート（VSCode 拡張の "File Templates" ブロック）---------
      -- セクションは jetbrains.kotlin ではなく jetbrains.templates.kotlin.<名前>。
      -- 「テンプレートから新規ファイル作成」用。値は IntelliJ の Velocity 形式:
      --   ${PACKAGE_NAME}=パッケージ名 / ${NAME}=ファイル名 / | =作成後のキャレット位置。
      -- 下記は VSCode 拡張の既定値そのまま。native 単体ではこれを呼ぶコマンドが無いため
      -- 現状はリファレンス兼テンプレ置き場（kotlin.nvim 等を入れると実際に効く）。
      templates = {
        kotlin = {
          Class = '#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME}\n\n#end\nclass ${NAME} {\n\t|\n}',
          File = '#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME}\n\n#end\n|',
          Interface = '#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME}\n\n#end\ninterface ${NAME} {\n\t|\n}',
          ["Data Class"] = '#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME}\n\n#end\ndata class ${NAME}(|)\n',
          Enum = '#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME}\n\n#end\nenum class ${NAME} {\n\t|\n}',
          Annotation = '#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME}\n\n#end\nannotation class ${NAME}(|)',
          Object = '#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")package ${PACKAGE_NAME}\n\n#end\nobject ${NAME} {\n\t|\n}',
        },
      },
    },

    -- ---- サーバ launcher 設定（VSCode 拡張の "IntelliJ Language Server" ブロック）---
    -- 元々は VSCode 拡張がサーバ起動時に使う設定で、kotlin-lsp 本体の機能設定ではない。
    -- native（vim.lsp）では基本 cmd / cmd_env / init_options 側で制御するため、settings に
    -- 置いても効かないものが多い（各行のコメント参照）。参照・将来の調整用に既定値で残す。
    intellij = {
      dev = {
        serverPort = -1,   -- 既定 -1（バンドルサーバを起動）。native は cmd の --stdio 接続なので無効
        logLaunch = false, -- 既定 false（launcher のデバッグログ）。native は launcher を介さない
        commands = false,  -- 既定 false（開発者向けコマンドを公開）
      },
      -- additionalJvmArgs = {},      -- 既定 [] JVM 追加引数。native は cmd_env(例: JAVA_TOOL_OPTIONS)で渡す
      -- buildTool = "",               -- 既定 null（null=自動判定 / ""=なし）。例 "gradle" / "maven"
      -- jdkForSymbolResolution = "",  -- 既定 null。シンボル解決用 JDK の絶対パス
      trace = {
        server = "off",    -- 既定 "off"。"messages"|"verbose" で LSP 通信トレース（:LspLog 相当）
      },
    },
  },
}

