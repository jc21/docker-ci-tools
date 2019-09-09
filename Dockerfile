FROM centos:7

MAINTAINER Jamie Curnow <jc@jc21.com>
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# Packages
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum localinstall -y https://yum.jc21.com/jc21-yum.rpm
RUN yum -y install deltarpm
RUN yum-config-manager --enable jc21-php72
RUN yum -y update
RUN yum -y install which git wget curl rpmdevtools rpmlint yum-utils expect s3cmd python2-pip createrepo python-magic rpm-sign php-cli jq hugo github-release
RUN curl -sfL https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin
RUN wget https://download.docker.com/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
RUN yum -y install docker-ce
RUN yum clean all
RUN rm -rf /var/cache/yum
RUN mkdir -p /data
RUN pip install --upgrade pip
RUN pip install awscli

WORKDIR /data

