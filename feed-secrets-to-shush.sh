#!/bin/bash

file_location=$1
kms_key=$2

display_usage() {
  echo "Usage: $0 <file-with-secrets> <kms-key-alias>"
  exit 1
}

if [  $# -le 1 ]; then
  display_usage
fi

while IFS= read -r line
do
  variable=$(echo $line | cut -f 1 -d =)
  value=$(echo $line | cut -f 2 -d =)

  if type shush >/dev/null 2>&1 eq 0; then
    encrypted_value=$(shush encrypt $kms_key $value)

    echo "KMS_ENCRYPTED_$variable: \"$encrypted_value\""
  else
    echo "Shush is not installed, please install it via: https://github.com/realestate-com-au/shush"
  fi
done < $file_location
