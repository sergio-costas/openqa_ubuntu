# Contributing OpenQA Tests

## Installation
```
sudo apt install openqa os-autoinst docker
```

Note: the docker installation is for if you'd like to run OpenQA on docker containers.

This contribution guide will use docker containers to run OpenQA tests.

## Scripts explanation

`fifloader.py` is a simple script which converts `templates.fif.json` into a raw json schema which is absorbed by OpenQA.

`env_vars` is a script which contains environmental variables needed for running the containers. The variables are:
    - container name prefix (`user`)
    - webport
    - rsyncport
    - sslport

Prior to starting the containers, when running locally, you can simply run `sudo chmod 666 /dev/kvm` to make the kvm module accessible to the openqa containers.

`start_containers` is pretty self explanatory. It simply starts the docker containers for `openqa` (`worker` and `webui`) using the variables set in `env_vars`.

`copy_resources_to_container` is a script which takes a path to a `.iso` file as an argument. It then copies the `.iso` file to the necessary directory for the docker containers to have access to them. It then copies the contents of this repository (via `cp`, not via a `git clone` or anything) to a similar directory for the docker containers. It also then runs `fifloader.py` to convert `templates.fif.json` to the appropriate format and places the output in a similar directory to the aforementioned directories.

`upload_template` uploads the template file created in `copy_resources_to_container` to the docker containers running openqa.

`trigger_build` starts all the jobs in the test suite defined in `templates.fif.json`.

## Needles and haystacks
The way openQA works, is based on the concepts of needles and haystacks. Needles are made up of a screenshot (taken from an install test) and a json file accompanying the screenshot which defines location of the image on the screen (entire window in install test, this is referred to as the "haystack"). The json also includes a unique tag, which is what you use to refer to the needles in the Perl scripts.

You create needles using the needle editor in the openqa webui. When a test fails, click on the failure and to the top right, you can see an icon with a plus sign, which if you click on it, takes you to the needle editor.

You can left click and drag your cursor in the needle editor to define a needle. Make sure to add the tag at the top before saving the needle.

## Writing tests

When writing a test, use the pre-existing ones as an example. Here's a vanilla install of `mantic`:
```
assert_screen 'try_or_install23_04', 200;
assert_and_click 'install_ubuntu_btn';
# assert_and_click 'install_ubuntu_btn23_04' if check_var('INSTALL_TYPE', 'install');
assert_and_click 'next23_04';
assert_screen 'keyboard_screen', 200;
assert_and_click 'next23_04';
assert_screen 'connection_screen', 100;
assert_and_click 'next23_04';
assert_screen 'applications_and_updates', 100;
assert_and_click 'next23_04';
assert_screen 'installation_type', 100;
assert_and_click 'next23_04';
assert_screen 'ready_to_install', 100;
assert_and_click 'install_button';
assert_screen 'timezone', 100;
assert_and_click 'uk', 100;
assert_and_click 'next23_04';
assert_screen 'login_info', 100;
type_string 'ubuntu', SLOW_TYPING_SPEED;
send_key 'tab';
send_key 'tab';
type_string 'ubuntu', SLOW_TYPING_SPEED;
send_key 'tab';
type_string 'ubuntu', SLOW_TYPING_SPEED;
send_key 'tab';
send_key 'tab';
type_string 'ubuntu', SLOW_TYPING_SPEED;
assert_and_click 'next23_04';
assert_screen 'theme_screen', 100;
assert_and_click 'next23_04';
assert_screen 'installed_screen', 1800;
assert_and_click 'installed_restart';
assert_screen 'reboot', 200;
send_key 'ret';
assert_screen 'installed_after_reboot', 200;
send_key 'ret';
type_string 'ubuntu', SLOW_TYPING_SPEED;
send_key 'ret';
assert_screen 'installed_desktop', 200;
```

As you can see, the functions you'll use mostly when writing tests are:
- `assert_screen`:
    - Waits for a needle, for a given amount of time. Fails if the needle is not seen within the specified timeframe.
- `assert_and_click`:
    - Waits for a needle, if found within a given timeframe, clicks the location of the needle (keep this in mind - these needles should generally be smaller than ones used for the previous function)
- `send_key`:
    - Types a key or combination of keys in the install tests.
- `type_string`:
    - Types a string in the install test with a given typing speed. It's best to use a slow typing speed as a fast typing speed can often type characters in the incorrect order.

I think these are basically the only functions required to write the majority of openQA tests.

When writing a test, place it in an appropriate directory under `tests`. Currently, there are three directories: `applications`, `installation` and `utils`. Don't place tests under `utils`. GUI application testing is done under `applications`, and installer testing is done under `installation`.

To test just your own test, examine `templates.fif.json`, and `products/ubuntu/main.pm`. You can swap the values around in these files to change which tests are being done, and to just run your test alone.

## Testing your own tests

When testing your own tests, this is the approach you should take, in order:

1. Get an iso for the development release (currently `mantic`)
2. run `sudo chmod 666 /dev/kvm`
3. navigate to the `scripts` directory
4. run `sudo ./start_containers`
5. run `sudo ./copy_resources_to_container /path/to/devel/iso`
6. run `./upload_template`
7. run `./trigger_build`
8. Run your test, wait for failure, save the needles and retry until success.
9. When you have a fully passing test, or want to save your progress needles wise, do:
```
cd /path/to/this/repo/openqa_ubuntu/products/ubuntu/needles
sudo rm ./*
sudo su
source env_vars
cd /var/lib/docker/volumes/"${user}"-Tests/_data/ubuntu/products/ubuntu/needles
cp -b ./* /path/to/this/repo/openqa_ubuntu/products/ubuntu/needles
# commit your needle changes
```

After this point, you can kill the containers with `kill_containers`.
CRUCIAL NOTE: IF YOU KILL THE CONTAINERS BEFORE SAVING THE NEEDLES MANUALLY, YOU WILL LOSE THE NEEDLES.
