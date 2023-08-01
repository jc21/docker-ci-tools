FROM --platform=${TARGETPLATFORM:-linux/amd64} debian:bookworm-slim

LABEL maintainer="Jamie Curnow <jc@jc21.com>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY scripts/install-tools.sh /tmp/install-tools.sh
RUN /tmp/install-tools.sh \
	&& rm -f /tmp/install-tools.sh

RUN mkdir -p /data
WORKDIR /data
