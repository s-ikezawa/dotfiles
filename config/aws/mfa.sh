#!/usr/bin/env bash

set -e

item_name="Olive AWS Console"
vault="ebisol inc."
account="my.1password.com"

aws-mfa --mfa-profile olive --token `op item get "${item_name}" --vault "${vault}" --account "${account}" --otp`
