#!/bin/bash

source env_vars

sudo docker exec $user-openqa_worker ls > /dev/null
if [ $? -eq 0 ]; then
        echo Copying needles
        ./copy_needles.sh
        echo "Killing old containers"
        sudo ./kill_containers
fi

echo "Launching new containers"
sudo ./start_containers
echo "Copying resources into the container"
sudo ./copy_resources_to_container $ISO_FILE
echo "Uploading the templates"
sudo ./upload_template
echo "Triggering build"
sudo ./trigger_build
