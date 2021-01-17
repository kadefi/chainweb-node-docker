#!/usr/bin/env bash

# Retries a command a configurable number of times with backoff.
#
# The retry count is given by ATTEMPTS (default 5), the initial backoff
# timeout is given by TIMEOUT in seconds (default 1.)
#
# Successive backoffs double the timeout.
function with_backoff() {
  local max_attempts=${ATTEMPTS-5}
  local timeout=${TIMEOUT-1}
  local attempt=1
  local exitCode=0

  while (($attempt < $max_attempts)); do
    if "$@"; then
      echo "Bootstrap downloaded creating $DBDIR"
      mkdir -p "$DBDIR"
      echo "Extracting bootstrap to $DBDIR"
      tar -xzvf bootstrap.tar.gz -C "$DBDIR"
      rm bootstrap.tar.gz
      echo "Bootstrap extract finish"
      return 0
    else
      exitCode=$?
    fi

    echo "Failure! Retrying in $timeout.." 1>&2
    sleep $timeout
    attempt=$((attempt + 1))
    timeout=$((timeout * 2))
  done

  if [[ $exitCode != 0 ]]; then
    rm -rf /data/chainweb-db/
    echo "Failed for the last time! ($@)" 1>&2
  fi

  return $exitCode
}

DBDIR="/data/chainweb-db/0"
# Double check if dbdir already exists, only download bootstrap if it doesn't
if [ -d $DBDIR ]; then
  echo "Directory $DBDIR already exists, we will not download any bootstrap, if you want to download the bootstrap you need to delete chainweb-db folder first"
else
  echo "$DBDIR does not exists, lets download the bootstrap"
  # Getting Kadena bootstrap from Zel Servers
  BOOTSTRAPLOCATIONS[0]="https://cdn-1.fluxos.network/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
  BOOTSTRAPLOCATIONS[1]="https://cdn-2.fluxos.network/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
  BOOTSTRAPLOCATIONS[2]="https://cdn-3.fluxos.network/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
  BOOTSTRAPLOCATIONS[3]="https://cdn-4.fluxos.network/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz"

  httpstatus=0
  retry=0
  while [ $httpstatus != "200" ] && [ "$retry" -lt 3 ]; do
    index=$(shuf -i 0-3 -n 1)
    echo "Testing bootstrap location ${BOOTSTRAPLOCATIONS[$index]}"
    httpstatus=$(curl --write-out '%{http_code}' --silent --connect-timeout 5 --head --output /dev/null ${BOOTSTRAPLOCATIONS[$index]})
    echo "Http status $httpstatus"
    retry=$(expr $retry + 1)
  done

  if [ $httpstatus == "200" ]; then
    echo "Bootstrap location valid"
    echo "Downloading bootstrap"
    # Install database
    with_backoff curl --keepalive-time 30 \
      -C - \
      -o bootstrap.tar.gz "${BOOTSTRAPLOCATIONS[$index]}"
  else
    echo "None bootstrap was found, will download blockchain from node peers"
  fi
fi
