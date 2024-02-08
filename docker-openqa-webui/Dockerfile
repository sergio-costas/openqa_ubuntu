FROM ubuntu:22.04
LABEL maintainer Sergio Costas Rodriguez <sergio.costas@canonical.com>
LABEL version="2024-02-07"

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends apache2 openqa postgresql

RUN a2enmod headers
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_wstunnel

# Config
RUN mkdir --parents /run/dbus
RUN echo ServerName localhost >> /etc/apache2/httpd.conf
RUN mkdir --parents /etc/apache2/vhosts.d
RUN cp /etc/apache2/sites-available/openqa.conf.template /etc/apache2/vhosts.d/openqa.conf
USER postgres
RUN ls /etc/postgresql
RUN ls /etc/postgresql/*
RUN /usr/bin/pg_ctlcluster --skip-systemctl-redirect 14 main start && \
    createuser geekotest && \
    createdb openqa && \
    psql --command='GRANT ALL PRIVILEGES ON DATABASE openqa TO geekotest;' && \
    /usr/bin/pg_ctlcluster --skip-systemctl-redirect -m fast 14 main stop
USER root
ADD client.conf /etc/openqa/
ADD database.ini /etc/openqa
ADD openqa.ini /etc/openqa/
ADD pg_hba.conf /usr/share/postgresql/14
RUN mkdir -p mkdir /var/lib/openqa/share/factory/tmp
RUN chmod 777 /var/lib/openqa/share/factory/tmp

# This script starts the necessary services.
ADD run_openqa.sh /root/
RUN chmod 755 /root
RUN chmod 755 /root/run_openqa.sh

EXPOSE 80 443
VOLUME [ "/var/lib/openqa/share/factory/" ]
VOLUME [ "/var/lib/openqa/testresults/" ]
VOLUME [ "/var/lib/pgsql/data/" ]
CMD ["/root/run_openqa.sh"]