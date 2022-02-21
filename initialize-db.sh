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
  BOOTSTRAPLOCATIONS[0]="http://91.229.245.161:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[1]="http://91.229.245.159:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[2]="http://89.58.33.204:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[3]="http://89.58.31.71:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[4]="http://89.58.35.6:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[5]="http://89.58.0.227:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[6]="http://202.61.202.227:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[7]="http://202.61.202.55:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[8]="http://89.58.26.125:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[9]="http://202.61.239.217:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[10]="https://fluxnodeservice.com/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[11]="http://144.91.67.82:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[12]="http://38.242.202.86:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=8ba005f55511d806f9d4ec5f56bf5c14ae02a50bfb80f5bdb08a1ded22f7b159"
  BOOTSTRAPLOCATIONS[13]="http://62.171.163.150:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=e557a11e150cc9a10f7a233615925955f940d92d008c4ecd36c8f0aed0ba6afe"
  BOOTSTRAPLOCATIONS[14]="http://173.212.251.209:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=3c46894384b3367f6490c8a56876cb0d87c2f6955b986790229244f1eccf190a"
  BOOTSTRAPLOCATIONS[15]="http://173.212.248.228:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=231ca0204b7d9f0b7550b0a2588846c11ac2715cc4d8e6761d5f3f3f49c887b1"
  BOOTSTRAPLOCATIONS[16]="http://144.91.117.51:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=b9f89999f5430544e7402eadca935ea497d0e1444cba514ceac1580fe6d99b5a"
  BOOTSTRAPLOCATIONS[17]="http://144.91.117.98:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=32a87201685f3667003829652ad7196d3694669a7d3928b58e9a77b8a0e9a809"
  BOOTSTRAPLOCATIONS[18]="http://161.97.85.103:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=01db43430e671ec3546f528c1981d7c1d7e6287b95956f319b0386625707981d"
  BOOTSTRAPLOCATIONS[19]="http://194.163.176.185:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=d3faf9d25c24d56c24667e68292ff1041364a82bc039cf0f86176d8af58d7043"
  BOOTSTRAPLOCATIONS[20]="http://194.163.176.186:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=082ecb3326e08d80430d2d92ba5f03bc150f068c3b36668fa9c655b46614f9b3"
  BOOTSTRAPLOCATIONS[21]="http://194.163.176.187:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=2a8b6b1167ad8b711678b4ad5ec85dc5460d3a34e94ed5fce62f9eaedf0ebe6f"
  BOOTSTRAPLOCATIONS[22]="http://194.163.176.188:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=e73bb06538f26963b387b18ad4e66adb9b21d9d1be718c2a22d553dcd82edc8d"
  BOOTSTRAPLOCATIONS[23]="http://89.58.9.63:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=9b299b477b56983ef37b9b58e8d38fbb2db880a1dc329d19d58c7ecd682cb87b"
  BOOTSTRAPLOCATIONS[24]="http://89.58.3.209:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=675c85498d3d97bf5a0d36608ac55be5d63903b3cd0d6e8a38d319e844987d60"
  BOOTSTRAPLOCATIONS[25]="http://213.136.76.42:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=158c7ef812485af84fa1f53b4effde49946fb3ce2cd82b62f1efe05473621fa1"
  BOOTSTRAPLOCATIONS[26]="http://161.97.85.110:16127/apps/fluxshare/getfile/kda_bootstrap.tar.gz?token=a305702e908096a4577019535aadfab41359e350c5123957b56eb1f71b840202"
  BOOTSTRAPLOCATIONS[27]="http://45.129.181.23:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"
  BOOTSTRAPLOCATIONS[28]="http://45.9.62.3:11111/apps/fluxshare/getfile/kda_bootstrap.tar.gz"

  retry=0
  file_lenght=0
  while [[ "$file_lenght" -lt "10000000000" && "$retry" -lt 6 ]]; do
    index=$(shuf -i 0-28 -n 1)
    echo "Testing bootstrap location ${BOOTSTRAPLOCATIONS[$index]}"
    file_lenght=$(curl -sI -m 5 ${BOOTSTRAPLOCATIONS[$index]} | egrep 'Content-Length|content-length' | sed 's/[^0-9]*//g')

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
