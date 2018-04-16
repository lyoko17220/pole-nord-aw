FROM debian:jessie

MAINTAINER tma@alterway.fr

# Install pygments (for syntax highlighting) 
RUN apt-get -qq update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends python-pygments git ca-certificates asciidoc \
	&& rm -rf /var/lib/apt/lists/*

# Download and install hugo
ARG HUGO_VERSION
ENV HUGO_VERSION ${HUGO_VERSION:-0.39}
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb


ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb \
	&& rm /tmp/hugo.deb

# Create working directory
RUN mkdir /usr/share/blog
WORKDIR /usr/share/blog

# Automatically build site
ARG SRC_ROOT
ENV SRC_ROOT ${SRC_ROOT:-www/}

ADD ${SRC_ROOT} /usr/share/blog

# By default, serve site
ARG HUGO_PORT
ENV HUGO_PORT ${HUGO_PORT:-1313}
ARG HUGO_BASE_URL
ENV HUGO_BASE_URL ${HUGO_BASE_URL:-http://localhost}

EXPOSE ${HUGO_PORT}

ENV SERVICE_1313_NAME polenord
ENV SERVICE_1313_TAGS http

ARG HUGO_THEME
ENV HUGO_THEME ${HUGO_THEME:-hugo-icarus-theme}

CMD hugo server -b ${HUGO_BASE_URL}:${HUGO_PORT} --bind=0.0.0.0 --theme=${HUGO_THEME} -s .
