FROM centos:7

MAINTAINER Jamie Curnow <jc@jc21.com>
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# Packages
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum localinstall -y https://yum.jc21.com/jc21-yum.rpm \
    && yum -y install deltarpm \
    && yum -y update \
    && yum -y install which git wget curl rpmdevtools rpmlint yum-utils expect s3cmd python2-pip createrepo python-magic rpm-sign php-cli jq hugo \
    && curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin \
    && wget https://download.docker.com/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo \
    && yum -y install docker-ce \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && mkdir -p /data \
    && pip install --upgrade pip \
    && pip install awscli

WORKDIR /data
