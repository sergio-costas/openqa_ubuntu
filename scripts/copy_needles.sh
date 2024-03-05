#/bin/bash

source ./env_vars

rm -rf ../products/ubuntu/needles
sudo docker exec $user-openqa_worker ptar -c -v -f /tmp/needles.tar -C /var/lib/openqa/share/tests/ubuntu/products/ubuntu needles
sudo docker cp $user-openqa_worker:/tmp/needles.tar ../products/ubuntu/
sudo docker exec $user-openqa_worker rm -f /tmp/needles.tar
tar xvf ../products/ubuntu/needles.tar -C ../products/ubuntu/
rm -f ../products/ubuntu/needles.tar
mv ../products/ubuntu/var/lib/openqa/share/tests/ubuntu/products/ubuntu/needles ../products/ubuntu/
rm -rf ../products/ubuntu/var