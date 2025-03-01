FROM debian:stable-slim

RUN apt-get update && apt-get install -y ca-certificates
RUN cd /usr/share/ca-certificates && mkdir mylocal && cp -p /etc/ca-certificates.conf /etc/ca-certificates.conf.bak

COPY ./certs/lets-note.lan.ca.crt  /certs/
RUN cd /usr/share/ca-certificates && cp /certs/lets-note.lan.ca.crt mylocal/
RUN echo "mylocal/lets-note.lan.ca.crt" >> /etc/ca-certificates.conf
RUN update-ca-certificates

RUN apt update && apt upgrade && apt install -y npm vim less curl

RUN cd / && curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o /minio-binaries/mc && \
    chmod +x /minio-binaries/mc
ENV PATH=$PATH:/minio-binaries/

RUN npm install -g typescript 

RUN addgroup --gid 1000 tool && adduser --uid 1000 --gid 1000 tool
RUN mkdir -p /home/tool/
RUN chown -R tool:tool /home/tool

USER 1000
WORKDIR /home/tool/
