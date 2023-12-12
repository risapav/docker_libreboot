FROM debian:stable-slim

ARG SCRIPTS=/opt/src/scripts
#ENV SCRIPTS=${SCRIPTS}

#
# increase the version to force recompilation of everything
#
ENV BUILDROOT_LIBREBOOT 0.0.1
#
# ------------------------------------------------------------------
# environment variables to avoid that dpkg-reconfigure 
# tries to ask the user any questions
#
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
# ------------------------------------------------------------------
# install needed packages to build and run buildroot and related sw
#
RUN apt-get update

RUN apt-get install -y --no-install-recommends \
	ca-certificates \
	git \
	locales

# ------------------------------------------------------------------
# prepare SDK
RUN git clone https://codeberg.org/libreboot/lbmk.git && \
	cd lbmk && \
	./build dependencies debian && \
	rm -R /lbmk

# ------------------------------------------------------------------
# set locale attrib
RUN sed -i "s/^# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && locale-gen && update-locale LANG=en_US.UTF-8

# ------------------------------------------------------------------
#
# prepare startup files in /opt/src/scripts
#

RUN mkdir -p ${SCRIPTS}

#WORKDIR ${SCRIPTS}
	
ADD ./*.sh ${SCRIPTS}/

#ENTRYPOINT ["/opt/src/scripts/startup.sh"]
#CMD ["/opt/src/scripts/entry.sh"]

#ENTRYPOINT ["$SCRIPTS/startup.sh"]
#CMD ["$SCRIPTS/entry.sh"]