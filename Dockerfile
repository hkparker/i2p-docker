FROM debian:stretch
 
ENV I2P_VERSION 0.9.36-2ubuntu1
ENV I2P_DIR /usr/share/i2p
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

##
# Expose some ports used by I2P
# Description at https://geti2p.net/ports
#
# Main ports:
# 2827 - BOB port
# 4444 — HTTP proxy
# 6668 — Proxy to Irc2P
# 7656 - SAM port
# 7657 — router console
# 7658 — self-hosted eepsite
# 7659 — SMTP proxy to smtp.postman.i2p
# 7660 — POP3 proxy to pop.postman.i2p
# 8998 — Proxy to mtn.i2p-projekt.i2p
##
EXPOSE 2827 7650 7654 7655 7656 7657 7658 7659 7660 7661 7662 4444 6668 8998

RUN apt-get -y update && \
    apt-get -y install \
	  apt-transport-https \
	  gnupg \
	&& \
    apt-get clean
RUN echo "deb https://deb.i2p2.de/ stretch main" > /etc/apt/sources.list.d/i2p.list && \
    apt-key adv --keyserver hkp://pgp.mit.edu --recv-key 0x67ECE5605BCF1346
RUN apt-get -y update && \
    apt-get -y install \
	  procps \
	  i2p="${I2P_VERSION}" \
	  i2p-keyring \
	  locales \
	&& \
    echo "RUN_AS_USER=i2psvc" >> /etc/default/i2p && \
    apt-get clean && \
    rm -rf /var/lib/i2p && \
	mkdir -p /var/lib/i2p/i2p-config && \
	chown -R i2psvc:i2psvc /var/lib/i2p && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*
 
# Enable UTF-8, mostly for I2PSnark
RUN sed -i 's/.*\(en_US\.UTF-8\)/\1/' /etc/locale.gen && \
    /usr/sbin/locale-gen && \
    /usr/sbin/update-locale LANG=${LANG} LANGUAGE=${LANGUAGE}
 
RUN sed -i 's/127\.0\.0\.1/0.0.0.0/g' ${I2P_DIR}/i2ptunnel.config && \
    sed -i 's/::1,127\.0\.0\.1/0.0.0.0/g' ${I2P_DIR}/clients.config && \
    printf "i2cp.tcp.bindAllInterfaces=true\n" >> ${I2P_DIR}/router.config && \
    printf "i2np.ipv4.firewalled=true\ni2np.ntcp.ipv6=false\n" >> ${I2P_DIR}/router.config && \
    printf "i2np.udp.ipv6=false\ni2np.upnp.enable=false\n" >> ${I2P_DIR}/router.config
 
VOLUME /var/lib/i2p
USER i2psvc
ENTRYPOINT ["/usr/bin/i2prouter"]
CMD ["console"]

