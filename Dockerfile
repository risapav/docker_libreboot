FROM debian:stable-slim

# Prepare directory for tools
ARG USERNAME=sdk
ARG CB_PATH=/home/${USERNAME}

ARG GITUSER="John Doe"
ARG GITEMAIL="johndoe@email.com"

# set locale attrib
RUN apt-get update && DEBIAN_FRONTEND=noninteractive && apt-get -y --no-install-recommends install locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8
  
ENV LANG en_US.UTF-8 

RUN apt-get update && \
  apt-get -y --no-install-recommends install apt-transport-https ca-certificates gettext git wget && \
  update-ca-certificates && \
  useradd -m ${USERNAME} && \
  mkdir -p ${CB_PATH} 

USER ${USERNAME}

# clone libreboot base and prepare dependencies	
RUN cd ${CB_PATH} && \
  git clone https://codeberg.org/libreboot/lbmk.git
  
  
USER root  
  
RUN cd ${CB_PATH}/lbmk && ./build dependencies debian && \
  chown ${USERNAME}:${USERNAME} -R ${CB_PATH}

USER ${USERNAME}

#ENV SHELL=/bin/bash
# Change workdir
WORKDIR ${CB_PATH}/lbmk
VOLUME ${CB_PATH}/lbmk/config


#CMD ["/bin/bash"]
