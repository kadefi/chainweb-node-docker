#!/usr/bin/env bash

DBDIR="/data/chainweb-db/0"
# Double check if dbdir already exists, only download bootstrap if it doesn't
if [ -d $DBDIR ] 
then
	echo "Directory $DBDIR already exists, we will not download any bootstrap, if you want to download the bootstrap you need to delete the folder first" 
else
	echo "$DBDIR does not exists, lets download the bootstrap"
	# Getting Kadena bootstrap from Zel Servers
	BOOTSTRAPLOCATIONS[0]="https://cdn-1.fluxos.network/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
	BOOTSTRAPLOCATIONS[1]="https://cdn-2.fluxos.network/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
	BOOTSTRAPLOCATIONS[2]="https://cdn-3.fluxos.network/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
	BOOTSTRAPLOCATIONS[3]="https://cdn-4.fluxos.network/zelapps/zelshare/getfile/db-chainweb-node-ubuntu.18.04-latest.tar.gz"
	
	httpstatus=0
	retry=0
	while [ $httpstatus != "200" ] && [ "$retry" -lt 3 ]
	do
	  index=$(shuf -i 0-3 -n 1)
	  echo "Testing bootstrap location ${BOOTSTRAPLOCATIONS[$index]}"
	  httpstatus=$(curl --write-out '%{http_code}' --silent --connect-timeout 5 --head --output /dev/null ${BOOTSTRAPLOCATIONS[$index]})
	  echo "Http status $httpstatus"
	  retry=`expr $retry + 1`
	done

	if [ $httpstatus == "200" ] 
	then
		echo "Bootstrap location valid"
		echo "Downloading bootstrap and extract it to $DBDIR"
		# Install database
		mkdir -p "$DBDIR" && \
		curl "${BOOTSTRAPLOCATIONS[$index]}" | tar -xzC "$DBDIR"
	else
		echo "None bootstrap was found, will download blockchain from node peers"
	fi
fi