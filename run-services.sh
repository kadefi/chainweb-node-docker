#!/usr/bin/env bash

# Starting Chainweb Node
echo "Starting Chainweb Node"
test -d /data/chainweb-db/0 && ./run-chainweb-node.sh || (/chainweb/initialize-db.sh && ./run-chainweb-node.sh) &

# Starting Pact DB API
export NODE_ENV="production"
export CHAINWEB_NETWORK=${CHAINWEB_NETWORK:-mainnet01}
export CHAINWEB_P2P_PORT=${CHAINWEB_P2P_PORT:-1789}

while ! (curl -fsLk "https://localhost:$CHAINWEB_P2P_PORT/chainweb/0.0/$CHAINWEB_NETWORK/cut")
do 
  echo "cut endpoint not up yet sleeping 30s"
  sleep 30s
done

echo "starting pact db api"
cd src && yarn start &

wait -n

exit $?
