#!/bin/bash

set -e

# Slack通知設定
SLACK_WEBHOOK_URL="${CLAUDE_TO_SLACK_WEBHOOK_URL}"

# 使用方法チェック
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <質問内容>"
    echo "例: $0 'この設定ファイルの形式は何ですか？'"
    exit 1
fi

# 引数から質問内容を取得
QUESTION="$*"

# Slack Webhook URLの確認
if [ -z "$CLAUDE_TO_SLACK_WEBHOOK_URL" ]; then
    echo "エラー: CLAUDE_TO_SLACK_WEBHOOK_URL環境変数が設定されていません"
    echo "設定方法: export CLAUDE_TO_SLACK_WEBHOOK_URL='https://hooks.slack.com/services/...'"
    exit 1
fi

# Slackメッセージペイロードを作成
PAYLOAD=$(cat <<EOF
{
    "text": "Claude Codeからの質問",
    "blocks": [
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": ":interrobang: Claude Codeからの質問"
            }
        },
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "$QUESTION"
            }
        }
    ]
}
EOF
)

# デバッグ用: コピペ可能なcurlコマンドを表示
# echo "=== デバッグ情報 ==="
# echo "以下のcurlコマンドをコピペして実行できます:"
# echo ""
# echo "curl -v -X POST -H 'Content-type: application/json' \\"
# echo "    --data '$PAYLOAD' \\"
# echo "    '$CLAUDE_TO_SLACK_WEBHOOK_URL'"
# echo ""
# echo "=================="

# Slackに通知送信
if curl -X POST -H 'Content-type: application/json' \
    --data "$PAYLOAD" \
    "$CLAUDE_TO_SLACK_WEBHOOK_URL" >/dev/null 2>&1; then
    echo "Slackに質問を送信しました: $QUESTION"
else
    echo "エラー: Slackへの送信に失敗しました"
    exit 1
fi
