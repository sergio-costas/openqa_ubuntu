# Ubuntu openqa

This is a repo for openqa testing of ubuntu desktop applications and installer testing.

A lot of the inspiration for this repo came from `https://github.com/drpaneas/ubuntu_qa`.

You must have docker installed for this to work.
```
curl -sSL https://get.docker.com/ | sudo sh
```

kvm must also be working on your machine. As a hack, I run `sudo chmod 666 /dev/kvm`.

There are scripts to help running the tests. Please run them from the `scripts` directory.

To run, navigate to the `scripts` directory, and run `sudo ./start_containers`.

Once the containers are started, navigate to `http://localhost:XX` where `XX` is the `webport` specified in `env_vars`.
At this page, verify the `openqa` server is up and running. Try changing the port and restarting the containers if it is not.

After this, run `sudo ./copy_resources_to_container /path/to/iso/file/for/testing.iso`. This will copy all the necessary files to run the test. This will copy all the necessary files to run the tests.

Then run `./upload_template`. This informs the openqa server about the machines you will use, the job groups and the test suite definitions etc. This essentially uploads the `templates` file. NOTE: the file is uploaded from the docker disk space, not where you have cloned this repo.
To update it, find it under `/var/lib/docker/volumes/container_name-Tests/_data/ubuntu`. Or, you can modify here and rerun `copy_resources_to_container`.

To run the test suite (there is only one currently), run `./trigger_build`. Right now, the only test is a short proof of concept test with `gnome-calendar`.

You can also run `sudo ./kill_containers` to destroy the containers and their disk space. After this, run `sudo systemctl restart docker.service` before restarting the containers.