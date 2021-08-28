# syntax=docker/dockerfile:experimental

# Run as
#
# --ulimit nofile=64000:64000

# BUILD PARAMTERS
ARG UBUNTUVER=20.04

FROM ubuntu:${UBUNTUVER}

ARG REVISION=4288c34
ARG GHCVER=8.10.5
ARG UBUNTUVER

LABEL revision="$REVISION"
LABEL ghc="$GHCVER"
LABEL ubuntu="$UBUNTUVER"

# install prerequisites
RUN apt-get update \
    && apt-get install -y librocksdb-dev curl xxd openssl binutils jq \
    && rm -rf /var/lib/apt/lists/*

# Install chainweb applications
WORKDIR /chainweb
# RUN curl -Ls "https://github.com/kadena-io/chainweb-node/releases/download/<chaineweb-version>/<chainweb-binary-version>" | tar -xzC "/chainweb/"
RUN curl -Ls "https://kadena-cabal-cache.s3.amazonaws.com/chainweb-node/chainweb.${GHCVER}.ubuntu-${UBUNTUVER}.${REVISION}.tar.gz" | tar -xzC "/"

COPY check-reachability.sh .
COPY run-chainweb-node.sh .
COPY initialize-db.sh .
COPY chainweb.yaml .
COPY check-health.sh .
RUN chmod 755 check-reachability.sh run-chainweb-node.sh initialize-db.sh check-health.sh
RUN mkdir -p /data/chainweb-db
RUN mkdir -p /root/.local/share/chainweb-node/mainnet01/

STOPSIGNAL SIGTERM
EXPOSE 443
EXPOSE 80
EXPOSE 1789
EXPOSE 1848
HEALTHCHECK --start-period=10m --interval=1m --retries=5 --timeout=10s CMD ./check-health.sh

CMD ./run-chainweb-node.sh
