FROM ubuntu:22.04
LABEL maintainer Sergio Costas Rodriguez <sergio.costas@canonical.com>
LABEL version="2024-02-07"

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends qemu-system-x86 qemu-system passwd openqa-worker libtime-moment-perl libcpanel-json-xs-perl
RUN /sbin/groupadd -g 109 -f kvm
RUN /sbin/usermod -a -G kvm _openqa-worker

# Config
ADD client.conf /etc/openqa/
ADD workers.ini /etc/openqa/

USER _openqa-worker
CMD ["/usr/share/openqa/script/worker", "--verbose", "--instance", "1"]

