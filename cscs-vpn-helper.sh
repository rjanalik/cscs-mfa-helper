#!/usr/bin/env bash

function getCredentials () {
  USERNAME="jradim"
  PASSWORD=$(pass cscs-vpn/$USERNAME | head -n1)
  TOTP=$(pass otp cscs-vpn/$USERNAME)
  USERNAME="${USERNAME}@cscs.ethz.ch"
}

function connect () {
    echo -e "$USERNAME\n$PASSWORD\n$TOTP\n" | $APP -s connect $HOST
}

function disconnect () {
    $APP -s disconnect
}

function state () {
    $APP -s state
}

function stats () {
    $APP -s stats
}

COMMAND=$1
HOST="sslvpn.ethz.ch/cscs"
APP="/opt/cisco/secureclient/bin/vpn"

case $COMMAND in
  "connect")
    echo "Connecting ${HOST} ..."
    getCredentials
    connect
    ;;
  "disconnect")
    echo "Disconnecting ${HOST} ..."
    disconnect
    ;;
  "state")
    echo "State ..."
    state
    ;;
  "status")
    echo "State ..."
    state
    ;;
  "stats")
    echo "Stats ..."
    stats
    ;;
  *)
    echo "Unknown command ${COMMAND}"
    echo "Command: [connect, disconnect, state, stats]"
    exit 1
    ;;
esac
