#===============
# gobuild
#===============

FROM --platform=${TARGETPLATFORM:-linux/amd64} golang:alpine AS gobuild

ARG GOPROXY
ARG GOPRIVATE

ENV GOPROXY=$GOPROXY \
	GOPRIVATE=$GOPRIVATE \
	GO111MODULE=on \
	CGO_ENABLED=1

RUN apk update
RUN apk add git make gcc g++
WORKDIR /workspace
RUN git clone https://github.com/cli/cli.git
WORKDIR /workspace/cli
RUN make

#===============
# Final image
#===============

FROM --platform=${TARGETPLATFORM:-linux/amd64} centos:8

LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# Packages
COPY --from=gobuild /workspace/cli/bin/gh /bin/gh
RUN dnf -y install epel-release
RUN dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf -y install https://yum.jc21.com/jc21-yum.rpm
RUN dnf -y install 'dnf-command(config-manager)'
RUN dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
RUN dnf -y module enable php:remi-7.4
RUN dnf -y update
RUN dnf -y install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
RUN dnf -y install docker-ce
RUN dnf -y install which git wget rpmdevtools rpmlint yum-utils expect s3cmd python3-pip createrepo python3-magic rpm-sign jq hugo php-cli php-common
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin
RUN dnf clean all
RUN rm -rf /var/cache/yum
RUN mkdir -p /data
RUN pip3 install --upgrade pip
RUN pip3 install awscli

WORKDIR /data
