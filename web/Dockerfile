FROM ubuntu/apache2:2.4-20.04_beta

RUN \
    apt-get update && \
    apt-get install -y \
        libapache-dbi-perl \
        libdbd-mysql-perl \
        libcgi-pm-perl \
        tzdata && \
    a2enmod cgid && \
    apt-get clean

ENV TZ="America/Sao_Paulo"

COPY ./conf/000-default.conf /etc/apache2/sites-available/000-default.conf
