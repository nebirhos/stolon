#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

KEEPER=${KEEPER-}
SENTINEL=${SENTINEL-}
PROXY=${PROXY-}

DATA_DIR=${DATA_DIR-/stolon-data}

function setup() {
  # use hostname command to get our pod's ip until downward api are less racy (sometimes the podIP from downward api is empty)
  export POD_IP=$(hostname -i)
}

function checkdata() {
  if [[ ! -e "$DATA_DIR" ]]; then
    echo "stolon data doesn't exist, data won't be persistent!"
    mkdir "$DATA_DIR"
  fi
  chown stolon:stolon "$DATA_DIR"
}

function launchkeeper() {
  checkdata
  export STKEEPER_LISTEN_ADDRESS=$POD_IP
  export STKEEPER_PG_LISTEN_ADDRESS=$POD_IP
  su stolon -c "stolon-keeper --data-dir $DATA_DIR"
}

function launchsentinel() {
  export STSENTINEL_LISTEN_ADDRESS=$POD_IP
  stolon-sentinel
}

function launchproxy() {
  export STPROXY_LISTEN_ADDRESS=$POD_IP
  stolon-proxy
}

echo "start"
setup
env

if [[ "${KEEPER}" == "true" ]]; then
  launchkeeper
  exit 0
fi

if [[ "${SENTINEL}" == "true" ]]; then
  launchsentinel
  exit 0
fi

if [[ "${PROXY}" == "true" ]]; then
  launchproxy
  exit 0
fi

exit 1
