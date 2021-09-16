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
  BOOTSTRAPLOCATIONS[0]="https://cdn-2.runonflux.io/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
  BOOTSTRAPLOCATIONS[1]="https://cdn-3.runonflux.io/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
  BOOTSTRAPLOCATIONS[2]="https://cdn-4.runonflux.io/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
  BOOTSTRAPLOCATIONS[3]="http://161.97.141.146:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=800e81149ef31cece36f95244c8c8bf7dc8f00e6ae146d1b3dc61b57c62cbad6"
  BOOTSTRAPLOCATIONS[4]="http://167.86.114.82:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=9a6880a4cd56a22ef3b675f8c46f49a41338970b52e8ef917fe4b69af3f76a2e"
  BOOTSTRAPLOCATIONS[5]="http://161.97.162.42:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=78ff7b29756bb33d28dd5851c56d36690d53eee649ac26160e10bb89bd524f37"
  BOOTSTRAPLOCATIONS[6]="http://5.189.163.60:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=4a1c1c060bdafd9a1f860e632a16ba0628afd5dbe5ac03d3360b063723ba356e"
  BOOTSTRAPLOCATIONS[7]="http://194.163.131.138:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=6af7cc13076167a7c47424c892e89de39344b80d37bcfe4b4ad1e8340230c0a6"
  BOOTSTRAPLOCATIONS[8]="http://173.212.230.38:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=590a9d459238efd9de7cad804c7a9b8ccaf0722b16902c4bab5a8bc96b4df74d"
  BOOTSTRAPLOCATIONS[9]="http://207.180.205.49:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=ec1df8edd0b022a26ef76feaa669609b2a6339673325a74adc8317904b82a7c2"
  BOOTSTRAPLOCATIONS[10]="http://75.119.145.216:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=37edfe0e8d0873f4d106eaf68fa28e438987f9e10a9d300cfff894e0e47f431c"
  BOOTSTRAPLOCATIONS[11]="http://95.111.233.193:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=066e48a5e7235155584c7307307845c109aa7a0159bee8d9655e0f8a5ec27daa"
  BOOTSTRAPLOCATIONS[12]="http://95.111.233.243:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=871d43eb267171f5d97a14dcd792bd8a1661ab90d31aa799eaa97a553f0267bc"
  BOOTSTRAPLOCATIONS[13]="http://94.16.104.218:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=5eebc4626d48cf22017f9a2688c3df67b5a3b4dbc445aa9f700f753cd39e10e6"
  BOOTSTRAPLOCATIONS[14]="http://202.61.202.55:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=28a693b8c709e53a56d1bb3ea6e92a7179fa13c0175aa1e98e9c82b7f017adbe"
  BOOTSTRAPLOCATIONS[15]="http://202.61.202.227:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=e176fd5e78f64a37843dfd753e432e0e6f25a992888129cf05019eb591d72b9d"
  BOOTSTRAPLOCATIONS[16]="http://63.250.53.25:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=0e5d002d9dbdde911652a98adef5af57477300302a64075a37c5d901931154ae"
  BOOTSTRAPLOCATIONS[17]="http://23.227.173.185:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=cd7e145ba8e7fd5fb3c449b1f34dee3dfe266767dcb7324d3caa801a144512b9"
  BOOTSTRAPLOCATIONS[18]="http://23.227.173.36:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=d287b5b51b92099ffa820f27d86ffb1eb345d690cacfe7d4c469fe857ed46920"
  BOOTSTRAPLOCATIONS[19]="http://149.255.39.59:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=a2690b1d3f219bb9fb19fd1006b82404e7055318f78aa6a685f09625531b06f5"
  BOOTSTRAPLOCATIONS[20]="http://149.255.39.23:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=7048acf9f01572773369fa18495b41ac4d7dce62a85952b6914423595cbcb412"
  BOOTSTRAPLOCATIONS[21]="http://104.225.221.7:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=aa23b010f0d4e29b9df7565f83358e065f853c093a458a8d87a3d10944671189"
  BOOTSTRAPLOCATIONS[22]="http://178.18.255.245:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=b9e63283cf935f2a81a5fcbe202fa53777d578cdafeaf556e999cd9feaa94d42"
  BOOTSTRAPLOCATIONS[23]="http://207.244.246.142:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=cc949e55fbb1acaa12f72ab07c4b9615f3fec28b1cdd8443e08dd1859994aecf"
  BOOTSTRAPLOCATIONS[24]="http://209.182.236.46:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=b1256ec3f00ab92b71439a6507b1fd9a9d6d4977095017fbb5e96f82997f9719"
  BOOTSTRAPLOCATIONS[25]="http://208.87.134.22:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=79fa8de9fff97c3959aeac822d1ca1c13a6c66fe438d7728c0c1e916b96c1ec3"
  BOOTSTRAPLOCATIONS[26]="http://104.225.216.235:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=cb231ce7bc94eca543f4d6b43140cfe3736dee9bc6b8febf04a610bb4d4e2ce3"
  BOOTSTRAPLOCATIONS[27]="http://172.93.48.193:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=96fa985a7e9e68d428eed5636e0e80b4e93e564fd0f0c443c9e8a1cda342d01c"
  BOOTSTRAPLOCATIONS[28]="http://89.233.105.188:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=e0521aefc555ae05456461859da11ff4466c2dc64e3ec7c07dfdc8b895d2165b"
  BOOTSTRAPLOCATIONS[29]="http://88.99.75.9:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=89566ce9ed35e707c8f6080170cf91da8719d4c558289595c1220b3469b72140"
  BOOTSTRAPLOCATIONS[30]="http://138.201.81.45:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=0bb8aff332785c130602523b493958f3372c89f4bcb6fa36ab18f2307e89bc49"
  BOOTSTRAPLOCATIONS[31]="http://88.198.84.161:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=b27e349d7f1fe82f8c0c2d9dede27849d02b409ee90a10ad4474f63b94a7aa5f"
  BOOTSTRAPLOCATIONS[32]="http://65.21.232.3:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=c30cb41458bd38259dd3a033196b8bda3004b3290aa5d3c96fad48c0b8c76c3d"
  BOOTSTRAPLOCATIONS[33]="http://94.130.117.177:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=96d6067a9716d2add00e66098a869589a89c48fa1e06bb79bcdcf4256b8953bb"
  BOOTSTRAPLOCATIONS[34]="http://144.76.253.209:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=b083465c727a4ed898b2d68aa7d88f4533da03be72061b074118a217ca28a515"
  BOOTSTRAPLOCATIONS[35]="http://193.200.241.142:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=ce243f512f40ff1e766b323a65bef77ccba6912e1fc3a45d0452637939bfb5d7"
  BOOTSTRAPLOCATIONS[36]="http://62.171.138.43:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=d52da6a32ef79297de2d76afd61d5e8f27297ff4ec261ffc6cfd8df2cf180d81"
  BOOTSTRAPLOCATIONS[37]="http://167.86.111.213:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=349a65c05cdfa2b39640322bce8ac0c7bb7be91a2390834716906760f1062096"
  BOOTSTRAPLOCATIONS[38]="http://164.68.116.151:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=bdf8cfcef36929d4c060d0e2a3fecba20f8897805dd81d2dba84814d2fb704fd"
  BOOTSTRAPLOCATIONS[39]="http://161.97.141.146:16127/apps/fluxshare/getfile/kdabootstrap.tar.gz?token=800e81149ef31cece36f95244c8c8bf7dc8f00e6ae146d1b3dc61b57c62cbad6"
  BOOTSTRAPLOCATIONS[40]="https://fluxnodeservice.com/kda_bootstrap.tar.gz"

  retry=0
  file_lenght=0
  while [[ "$file_lenght" -lt "10000000000" && "$retry" -lt 6 ]]; do
    index=$(shuf -i 0-40 -n 1)
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
