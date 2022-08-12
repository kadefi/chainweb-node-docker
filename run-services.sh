#!/usr/bin/env bash

# Starting Chainweb Node
echo "Starting Chainweb Node"
test -d /data/chainweb-db/0 && ./run-chainweb-node.sh || (/chainweb/initialize-db.sh && ./run-chainweb-node.sh) &

# Starting Pact DB API
export NODE_ENV="production"
cd src && yarn start &

wait -n

exit $?
