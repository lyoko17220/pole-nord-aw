FROM debian:jessie

MAINTAINER tma@alterway.fr

# Install pygments (for syntax highlighting) 
RUN apt-get update && apt-get install -y \
    git \
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

# Website directory
ARG SRC_ROOT=www/
ENV SRC_ROOT ${SRC_ROOT}

ADD ${SRC_ROOT} /usr/share/blog

ARG HUGO_PORT=1313
ENV HUGO_PORT ${HUGO_PORT}

EXPOSE ${HUGO_PORT}

# URL for load ressources
ARG HUGO_BASE_URL=http://localhost
ENV HUGO_BASE_URL ${HUGO_BASE_URL}

ENV SERVICE_1313_NAME polenord
ENV SERVICE_1313_TAGS http

CMD hugo server -b ${HUGO_BASE_URL} -p ${HUGO_PORT} --appendPort=false --bind=0.0.0.0 -s .
