FROM debian:stable-slim

#
# increase the version to force recompilation of everything
#
ENV BUILDROOT_MIPS4KC 0.8.5
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
#    bash \
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
# prepare startup files in /src/misc
#
RUN mkdir -p /src/misc
COPY *.sh /src/misc/
RUN chmod a+x /src/misc/*.sh

ENTRYPOINT ["/src/misc/startup.sh"]
CMD ["/src/misc/entry.sh"]
