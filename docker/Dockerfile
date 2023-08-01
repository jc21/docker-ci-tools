FROM --platform=${TARGETPLATFORM:-linux/amd64} debian:bookworm-slim

LABEL maintainer="Jamie Curnow <jc@jc21.com>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY docker/scripts/install-tools.sh /tmp/install-tools.sh
RUN /tmp/install-tools.sh \
	&& rm -f /tmp/install-tools.sh

RUN mkdir -p /data
WORKDIR /data

LABEL org.label-schema.schema-version="1.0" \
	org.label-schema.license="MIT" \
	org.label-schema.name="ci-tools" \
	org.label-schema.description="Common Tools based on Debian for use in CI" \
	org.label-schema.url="https://github.com/jc21/docker-ci-tools" \
	org.label-schema.vcs-url="https://github.com/jc21/docker-ci-tools.git" \
	org.label-schema.cmd="docker run --rm -ti jc21/ci-tools:latest"
