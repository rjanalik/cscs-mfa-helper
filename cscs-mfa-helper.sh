#!/usr/bin/env bash

function getCredentials () {
  USERNAME="rjanalik"
  PASSWORD=$(pass cscs/$USERNAME)
  TOTP=$(pass otp cscs/$USERNAME)
}

function needNewKey () {
    return 0
  KEY_FILE="~/.ssh/cscs-key"

  #if [ ! -f $KEY_FILE ];
  if [ ! -f ~/.ssh/cscs-key ];
  then
  echo file does not exist
    return 0    # ssh key does not exist => generate new one
  fi

  KEY_TIMESTAMP_S=$(date -r ~/.ssh/cscs-key "+%s")
  NOW_S=$(date "+%s")
  KEY_TIMEOUT_S=$((24*60*60))    # 24h

  KEY_AGE_S=$((NOW_S-KEY_TIMESTAMP_S))

  [ $KEY_AGE_S -gt $KEY_TIMEOUT_S ]  # generate new key if it is expired (too old)
}

function generateNewKey () {
    echo -e "$USERNAME\n$PASSWORD\n$TOTP\nn\n" | bash $(dirname $0)/sshservice-cli/cscs-keygen.sh
}

if needNewKey;
then
  echo Generating new ssh key ...
  getCredentials
  generateNewKey
else
  echo The ssh key is still valid ...
fi
