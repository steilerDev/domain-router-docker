FROM nginx:1.21
ENV DEBIAN_FRONTEND noninteractive

# Applying fs patch for assets
ADD rootfs.tar.gz /

# Install stuff and remove caches
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install \
        --no-install-recommends \
        --fix-missing \
        --assume-yes \
            apt-utils curl gettext-base && \
    apt-get clean autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN chmod +x /docker-entrypoint.d/entry.sh