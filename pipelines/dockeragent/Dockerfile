# Download Docker CLI
FROM alpine:latest as dockercli

ARG DOCKER_VERSION=18.09.0

RUN wget -O docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz && \
    tar -xvzf docker.tgz && \
    chmod +x docker/docker

# Documented at https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux
FROM ubuntu:16.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl3 \
        libicu55 \
        zip \
        unzip

WORKDIR /azp

COPY ./start.sh .
RUN chmod +x start.sh

# User is required for the Docker Sock
USER root 
COPY --from=dockercli docker/docker /usr/local/bin/docker

CMD ["./start.sh"]

    