FROM debian:stable-slim

ARG SCRIPTS=/opt/src/scripts

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

# entry_point.sh
RUN echo "#!/bin/sh\n\
# set -ex\n\
echo \$PWD\n\
mkdir -p ~/lbmk\n\
cd ~/lbmk\n\
# Git\n\
if ! git ls-files >& /dev/null; then\n\
  git clone https://codeberg.org/libreboot/lbmk.git ~/lbmk --progress 2>&1\n\
fi\n\
" > ${SCRIPTS}/entry_point.sh	

# startup.sh
RUN echo "#!/bin/sh\n\
# set -ex\n\
#\n\
# add current user and user\'s primary group\n\
#\n\
groupadd -g  \$GGID  \$GGROUP\n\
useradd  -u  \$GUID -s \$GSHELL -c  \$GUSERNAME -g  \$GGID -M -d  \$GHOME  \$GUSERNAME\n\
usermod  -a -G sudo  \$GUSERNAME\n\
echo  \$GUSERNAME:docker | chpasswd\n\
if [ \"\$GRUNXTERM\" = \"1\" ]\n\
then\n\
# become the current user and start a shell\n\
  su -l -c lxterminal  \$GUSERNAME\n\
# another root shel\n\
  source  \$1\n\
  lxterminal\n\
else\n\
# become the current user and start a shell\n\
  su -l  \$GUSERNAME -c \"source  \$1\"\n\
  su -l  \$GUSERNAME\n\
# another root shell\n\
# /bin/bash\n\
fi\n\
" > ${SCRIPTS}/startup.sh
	
RUN chmod +x ${SCRIPTS}/*.sh; \
  ls -la ${SCRIPTS}/

ENTRYPOINT ["/opt/src/scripts/startup.sh"]

CMD ["/opt/src/scripts/entry.sh"]

#CMD /bin/bash
