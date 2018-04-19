FROM centos:7

MAINTAINER Jamie Curnow <jc@jc21.com>
LABEL maintainer="Jamie Curnow <jc@jc21.com>"

# Yum
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum localinstall -y https://yum.jc21.com/jc21-yum.rpm \
    && yum -y install deltarpm \
    && yum -y update \
    && yum -y install which git wget curl rpmdevtools rpmlint yum-utils expect s3cmd python2-pip createrepo python-magic \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && mkdir -p /data \
    && pip install --upgrade pip \
    && pip install awscli

WORKDIR /data
