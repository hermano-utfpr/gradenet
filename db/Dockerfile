FROM ubuntu/mysql:8.0-20.04_beta

RUN apt-get update && \
    apt-get install -y \ 
        tzdata && \
    apt-get clean

ENV TZ="America/Sao_Paulo"

COPY ./conf/my-local.cnf /etc/mysql/conf.d/my-local.cnf
