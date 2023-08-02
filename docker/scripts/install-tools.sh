#!/bin/bash -e

S3CMD_VERSION=2.3.0

# pkgs
echo '+-------------------------+'
echo '| packages                |'
echo '+-------------------------+'
apt update
apt install -y --no-install-recommends \
	awscli \
	ca-certificates \
	curl \
	git \
	hugo \
	jq \
	openssl \
	wget \
	which \
	php-cli \
	php-common

ln -s /usr/bin/python3 /usr/bin/python

# s3cmd
echo '+-------------------------+'
echo '| s3cmd                   |'
echo '+-------------------------+'
wget -O /tmp/s3cmd.tgz "https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_VERSION}/s3cmd-${S3CMD_VERSION}.tar.gz"
cd /tmp
tar -xzf s3cmd.tgz
mv /tmp/s3cmd-${S3CMD_VERSION} /s3cmd
rm -rf /tmp/s3cmd*

# node-prune
echo '+-------------------------+'
echo '| node-prune              |'
echo '+-------------------------+'
curl -sf https://gobinaries.com/tj/node-prune | sh

# docker
echo '+-------------------------+'
echo '| docker                  |'
echo '+-------------------------+'
curl -sfL https://get.docker.com/ | sh
apt remove -y docker-ce
apt autoremove -y

# gh cli
echo '+-------------------------+'
echo '| github cli              |'
echo '+-------------------------+'
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null
apt update
apt install gh -y

# cleanup
echo '+-------------------------+'
echo '| cleanup                 |'
echo '+-------------------------+'
apt clean
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/* /var/log/* /tmp/* /var/lib/dpkg/status-old
