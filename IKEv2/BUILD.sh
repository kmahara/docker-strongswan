#!/bin/sh

# =================================================================

command -v jq > /dev/null

if [ $? = 0 ]; then
	PROXY_IP=`(docker inspect proxy | jq -r .[0].NetworkSettings.Networks.bridge.IPAddress) 2> /dev/null`

	if [ "$PROXY_IP" != null ]; then
		echo "use proxy: $PROXY_IP"
		OPT="--build-arg http_proxy=$PROXY_IP:3128"
	else
		echo "## If you want build with proxy, run proxy container"
		echo "## see: https://github.com/kmahara/docker-proxy.git"
		exit 1
	fi
else
	echo "## If you want build with proxy, install jq"
	echo "## for centos: yum -y install jq"
	exit 1
fi

# =================================================================
echo "## Build Docker Image"

START_TIME=$SECONDS

docker-compose build $OPT

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "Duration: $ELAPSED_TIME secs"
