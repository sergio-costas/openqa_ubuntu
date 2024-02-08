#!/bin/bash

/usr/bin/pg_ctlcluster --skip-systemctl-redirect 14 main start

/usr/share/openqa/script/upgradedb --user geekotest --upgrade_database
# run services
dbus-daemon --system --fork --nopidfile
su -s /bin/bash -c '/usr/share/openqa/script/openqa-scheduler daemon' geekotest &
su -s /bin/bash -c '/usr/share/openqa/script/openqa-websockets daemon' geekotest &
apache2ctl start
su -s /bin/bash -c '/usr/share/openqa/script/openqa prefork -m production --proxy' geekotest

echo launched all
sleep 300