#=========================================================
# Stage 1: Download Docker CLI & Docker App binaries 
#=========================================================
FROM alpine:latest AS dockercli

ARG DOCKER_BRANCH=test
ARG DOCKER_VERSION=19.03.0-beta4

RUN wget --output docker.tgz https://download.docker.com/linux/static/${DOCKER_BRANCH}/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar -zxvf docker.tgz && \
    chmod +x docker/docker

#=========================================================
# Stage 2: Download kubectl binary 
#=========================================================
FROM alpine:latest AS kubectl

ARG KUBECTL_VERSION=v1.14.1

RUN wget --output ./kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl

#=========================================================
# Stage 3: Download Helm binary 
#=========================================================
FROM alpine:latest AS helm

ARG HELM_VERSION=v2.13.1

RUN wget --output helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm.tar.gz && \
    chmod +x linux-amd64/helm

#=========================================================
# Stage 4: Download docker-app binary
# Note: will soon be included with Docker CLI from 19.03+ 
#=========================================================
FROM alpine:latest AS docker-app

RUN export OSTYPE="$(uname | tr A-Z a-z)" && \
    wget --output "/tmp/docker-app-${OSTYPE}.tar.gz" "https://github.com/docker/app/releases/download/v0.6.0/docker-app-${OSTYPE}.tar.gz" && \
    tar xf "/tmp/docker-app-${OSTYPE}.tar.gz" -C /tmp/

#=========================================================
# Stage 4: Setup Azure Pipelines remote agent 
# Documented at https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux
#=========================================================
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

# Copy binaries from earlier build stages
RUN mkdir --parents ~/.docker/cli-plugins
COPY --from=dockercli docker/docker /usr/local/bin/docker
COPY --from=kubectl ./kubectl /usr/local/bin/kubectl
COPY --from=helm /linux-amd64/helm /usr/local/bin/helm
# COPY --from=docker-app /tmp/docker-app-linux /usr/local/bin/docker-app

CMD ["./start.sh"]

    
