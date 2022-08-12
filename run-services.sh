#!/usr/bin/env bash

# Starting Chainweb Node
echo "Starting Chainweb Node"
test -d /data/chainweb-db/0 && ./run-chainweb-node.sh || (/chainweb/initialize-db.sh && ./run-chainweb-node.sh) &

# Starting Pact DB API
export NODE_ENV="production"
export CHAINWEB_NETWORK=${CHAINWEB_NETWORK:-mainnet01}
export CHAINWEB_P2P_PORT=${CHAINWEB_P2P_PORT:-1789}

CURRENT_TIME=$(date '+%s')
BASE_TIME=1625422726
BASE_HEIGHT=35347955
TIME_DIFF=$((CURRENT_TIME-BASE_TIME))
BLOCKS_PASSED_DIFF=$((TIME_DIFF/30*20))
CURRENT_BLOCK_EST=$((BASE_HEIGHT+BLOCKS_PASSED_DIFF))
MIN_ACCEPTED_HEIGHT=$((CURRENT_BLOCK_EST-18000))
CURRENT_NODE_HEIGHT=$(curl -fsLk "https://localhost:$CHAINWEB_P2P_PORT/chainweb/0.0/$CHAINWEB_NETWORK/cut" | jq '.height')
echo "Current: $CURRENT_NODE_HEIGHT Expected: $MIN_ACCEPTED_HEIGHT"

while ! ((CURRENT_NODE_HEIGHT>MIN_ACCEPTED_HEIGHT))
do
  echo "Chainweb node not synced yet, waiting for 30s"
  sleep 30s
  CURRENT_TIME=$(date '+%s')
  BASE_TIME=1625422726
  BASE_HEIGHT=35347955
  TIME_DIFF=$((CURRENT_TIME-BASE_TIME))
  BLOCKS_PASSED_DIFF=$((TIME_DIFF/30*20))
  CURRENT_BLOCK_EST=$((BASE_HEIGHT+BLOCKS_PASSED_DIFF))
  MIN_ACCEPTED_HEIGHT=$((CURRENT_BLOCK_EST-18000))
  CURRENT_NODE_HEIGHT=$(curl -fsLk "https://localhost:$CHAINWEB_P2P_PORT/chainweb/0.0/$CHAINWEB_NETWORK/cut" | jq '.height')
  echo "Current: $CURRENT_NODE_HEIGHT Expected: $MIN_ACCEPTED_HEIGHT"
done

echo "Chainweb Node is synced, starting PACT API"
cd src && yarn start &

wait -n

exit $?
