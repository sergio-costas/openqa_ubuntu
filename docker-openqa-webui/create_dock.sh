#!/bin/sh

docker stop test-openqa_webui
docker rm test-openqa_webui
docker builder prune -f -a

docker build --no-cache --progress plain -t localbuntu/webui-x86_64 .
docker run -i --privileged --name test-openqa_webui localbuntu/webui-x86_64
