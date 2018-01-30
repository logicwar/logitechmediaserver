FROM phusion/baseimage:0.10.0

#########################################
##             SET LABELS              ##
#########################################

# set version and maintainer label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Logicwar <logicwar@gmail.com>"


#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set correct environment variables
ENV HOME="/root" LC_ALL="C.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]


#########################################
##          DOWNLOAD PACKAGES          ##
#########################################

# Download and install Dependencies
RUN \
 echo "**** Install Dependencies ****" && \
 apt-get update && \
 apt-get install -y \
	libio-socket-ssl-perl \
	lame faad flac sox \
	wget && \
 rm -rf \
	/var/lib/apt/lists/* \	
	/tmp/* \
	/var/tmp/*

# Download and install Main Software
RUN \
 echo "**** Install latest Logitech Media Server package ****" && \
 os=$(dpkg --print-architecture) && \
 if [ "$os" = "armhf" ]; then os=arm; fi &&\
 url="http://www.mysqueezebox.com/update/?version=7.9.1&revision=1&geturl=1&os=deb$os" && \
 latest_lms=$(wget -q -O - "$url") && \
 mkdir -p /sources && \
 cd /sources && \
 wget $latest_lms && \
 lms_deb=${latest_lms##*/} && \
 dpkg -i $lms_deb && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/sources


#########################################
##       COPY & RUN SETUP SCRIPT       ##
#########################################
# copy setup, default parameters and init files
COPY root/ /

# set permissions and run setup script
RUN \
 chmod -R +x /etc/service/ && \
 chmod +x /setup.sh; sync && \
 /setup.sh && \
 rm /setup.sh


#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

EXPOSE 3483 3483/udp 9000
VOLUME /config /music /playlist

