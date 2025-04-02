#!/usr/bin/env bash

usage() {
  echo "
1Passwordを利用したAWS CLI用のCredential helper

usage:
  $0 [-h / --help] : ヘルプを表示します。
  $0 <ITEM> [-v|--vault <VAULT>] [-a|--account <ACCOUNT>]
    ITEM           : 認証情報を保存している1Passwordのアイテム名を指定します。
    -v | --vault   : 認証情報を保存している保管庫名を指定します。未指定の場合はPrivateになります。
    -a | --account : 1Passwordのアカウントを指定します。未指定の場合はmy.1password.comになります。
  " >&2
}

account="my.1password.com"
vault="Private"
pos_args=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help) usage; exit 1;;
    -v|--vault) vault="${2}"; shift; shift;;
    -a|--account) account="${2}"; shift; shift;;
    *) pos_args+=("$1"); shift;;
  esac
done

# オプションが指定されていないパラメータ（位置引数）だけを並べ直す
# "hoge -p fuga piyo"というパラメータが"hoge piyo"となる
set -- "${pos_args[@]}"

item_name="$1"
if [ "${item_name}" == "" ]; then
  usage
  exit 1
fi
 
cat <<END
{
  "Version": 1,
  "AccessKeyId": "$(op item get "${item_name}" --vault "${vault}" --account "${account}" --fields label=aws_access_key_id)",
  "SecretAccessKey": "$(op item get "${item_name}" --vault "${vault}" --account "${account}" --fields label=aws_secret_access_key --reveal)"
}
END
