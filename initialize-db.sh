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
  BOOTSTRAPLOCATIONS[4]="http://62.171.173.1:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=893c39e311f349811f23d947714b8a3771e714405379c2ff68a45d69de00cea0"
  BOOTSTRAPLOCATIONS[5]="http://76.67.214.247:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=eec3f873005bce7feee77a67301e201c403ffa74d37686af06fed676accd3d48"
  BOOTSTRAPLOCATIONS[6]="http://62.171.147.231:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=35ada1ffb536c4a07caf668dd51bff4c7a31c38b682408b14f8b6a0377404e29"
  BOOTSTRAPLOCATIONS[7]="http://208.87.129.222:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=28519ea8a949df9a900154eb003a0fb1226d1f2fe44de38ef5d608cac75f4012"
  BOOTSTRAPLOCATIONS[8]="http://95.111.241.12:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=6aca11597a823d15e25fc2d9454ceb88a51cc018c9138008974acba982028cd1"
  BOOTSTRAPLOCATIONS[9]="http://207.180.248.154:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=9e2102c5ab0434c9c7704aeee963c2d26d3c9cc94762a7eecc1f6d4fe83ff02a"
  BOOTSTRAPLOCATIONS[10]="http://193.188.15.155:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=8dc2f09222b538a1630d6b312cfcff9d622bf262e3dc3e55f5217b21f36f95e2"
  BOOTSTRAPLOCATIONS[11]="http://62.171.190.234:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=b02d68e451f65361544b734320978dc194d734dae877f53925987c5b12fc5370"
  BOOTSTRAPLOCATIONS[12]="http://173.249.46.102:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=7e0f1644205d2b40d7ba16c91e6f023f1cb3dbdab5b3bfdf654944a22c9f0396"
  BOOTSTRAPLOCATIONS[13]="http://173.249.51.34:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=0919d90f2d7af3f43be9c08f2415a25afd30751817063f579acb7427ac0afde6"
  BOOTSTRAPLOCATIONS[14]="http://193.188.15.152:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=d78131144a1e5e2a0a5a9e19129668b4d9ffeb42b7818dc4ba55b5a9698280da"
  BOOTSTRAPLOCATIONS[15]="http://193.188.15.154:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=c0eab364891467eb443974533615bede91526a8e453b8267a584ee7ee6b6cb46"
  BOOTSTRAPLOCATIONS[16]="http://95.111.251.163:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=daa05a6a7e6f8ca43cfd6dab3ec752cc0d80be50db6733030895807a58ad2680"
  BOOTSTRAPLOCATIONS[17]="http://173.212.192.3:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=7d3c928566ce42f0186e19785af27483bb831ecfd90f9a584c9cfea30dc1603e"
  BOOTSTRAPLOCATIONS[18]="http://207.180.244.43:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=26124b7e7daac293648d69fab860669f35b8ed55becd35150a396fc5f7134e26"
  BOOTSTRAPLOCATIONS[19]="http://207.180.235.244:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=1fe7b40c4adfb5e1dc05c96458d0c6b2c7758ea3265ce8f19d60d0b0d8e611a1"
  BOOTSTRAPLOCATIONS[20]="http://207.180.244.236:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=9e00fe048c05117622621c82e8dd7e80445884c2ea00b4b47ae17fa369c79a31"
  BOOTSTRAPLOCATIONS[21]="http://161.97.154.69:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=d9c51c1306a1bdfe0a8424fa2d101a418bea4e0d38b939bb16245424f02426b9"
  BOOTSTRAPLOCATIONS[22]="http://207.180.250.106:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=09a7392d1bdfb184ab2c2af84ed8148dde6c621a1e98505c117238610cd0c65d"
  BOOTSTRAPLOCATIONS[23]="http://207.180.240.218:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=e12c9a4eb93d489b7e431fc0ca71696aa01af6cacea0a7d5184df695ceb4ba6c"
  BOOTSTRAPLOCATIONS[24]="http://193.188.15.153:16127/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz?token=18c77c36d1db8d7b81a5a9066d9cacd465b906c41fd763a4490b3c5e1edc2ddb"

  retry=0
  file_lenght=0
  while [[ "$file_lenght" -lt "10000000000" && "$retry" -lt 4 ]]; do
    index=$(shuf -i 0-24 -n 1)
    echo "Testing bootstrap location ${BOOTSTRAPLOCATIONS[$index]}"
    file_lenght=$(curl -sI  -m 5 ${BOOTSTRAPLOCATIONS[$index]} | grep 'Content-Length' | sed 's/[^0-9]*//g')

    if [[ "$file_lenght" -gt "10000000000" ]]; then
      echo "File lenght: $file_lenght"
    else
      echo "File not exist! Source skipped..."
    fi
    retry=$(expr $retry + 1)
  done


  if [[ "$file_lenght" -gt "10000000000" ]]; then
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
