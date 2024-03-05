#!/bin/bash

source env_vars

echo "Killing old containers"
sudo ./kill_containers
echo "Launching new containers"
sudo ./start_containers
echo "Copying resources into the container"
sudo ./copy_resources_to_container $ISO_FILE
echo "Uploading the templates"
sudo ./upload_template
echo "Triggering build"
sudo ./trigger_build
