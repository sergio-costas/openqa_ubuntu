#!/bin/bash

sudo ./kill_containers
sudo ./start_containers
sudo ./copy_resources_to_container /home/raster/workspace/ubuntu-core-desktop/ubuntu-core-desktop/ubuntu-core-desktop-22-amd64.iso
sudo ./upload_template
sudo ./trigger_build

# copy the created/modified needles
