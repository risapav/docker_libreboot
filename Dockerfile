FROM debian:stable-slim

# Prepare directory for tools
ARG USERNAME=sdk
ARG CB_PATH=/home/${USERNAME}


# set locale attrib
RUN apt-get update && DEBIAN_FRONTEND=noninteractive && apt-get -y --no-install-recommends install locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8
  
ENV LANG en_US.UTF-8 

# resolve paths and certificates
RUN apt-get update && apt-get -y --no-install-recommends install \
  gettext  \
  git  \
  wget  \
  --reinstall ca-certificates && \
  mkdir -p /usr/local/share/ca-certificates/cacert.org && \
  wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt && \
  update-ca-certificates
  
# clone libreboot base and prepare dependencies	
RUN useradd -m ${USERNAME} && mkdir -p ${CB_PATH} && cd ${CB_PATH} &&\
	git config --global user.name "John Doe" && \
	git config --global user.email "johndoe@email.com" && \ 
  git config --global http.sslCAinfo /etc/ssl/certs/ca-certificates.crt && \
  git config --system --add safe.directory '*' && \ 
  git clone https://codeberg.org/libreboot/lbmk.git && \
	cd lbmk && ./build dependencies debian && \
	cp /root/.gitconfig ${CB_PATH}/ && \
  chown ${USERNAME}:${USERNAME} -R ${CB_PATH} && ls -la /home

USER ${USERNAME}

#RUN 	./build fw coreboot x220_8mb

# prepare libreboot SDK and precompile payloads
#RUN ./update project trees -b seabios  && \
#  ./update project trees -b u-boot  && \
#  ./build fw grub && \
#	./build fw coreboot x220_8mb

#COPY t420.bin /lbmk
#RUN ./blobutil extract t420_8mb t420.bin
#RUN ./build boot roms t420_8mb
#RUN for f in bin/t420_8mb/*.rom; do ./blobutil inject -r $f -b t420_8mb; done

#ENV SHELL=/bin/bash
# Change workdir
WORKDIR ${CB_PATH}/lbmk
VOLUME ${CB_PATH}/lbmk/config

#RUN ./update trees -b coreboot utils && \
#	./update trees -b seabios && \
#	./update trees -b grub && \
#	./update trees -b memtest86plus
	

#CMD ["/bin/bash"]
