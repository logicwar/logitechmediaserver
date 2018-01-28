#!/bin/sh

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Disable unecessary services (SSH, Syslog and Cron)
rm -rf /etc/service/sshd /etc/service/cron /etc/service/syslog-ng /etc/my_init.d/00_regen_ssh_host_keys.sh /etc/my_init.d/10_syslog-ng.init


#########################################
##           CREATE FOLDERS            ##
#########################################
# Media folders
mkdir \
	/music \
	/playlist

# Make sure the "squeezeboxserver" script will not create them with 'root' ownership later
mkdir -p \
	/config/logs \
	/config/prefs/plugin \
	/config/cache/audioUploads \
	/config/cache/InstalledPlugins \
	/config/cache/DownloadedPlugins \
	/config/cache/updates

touch /config/logs/perfmon.log
touch /config/logs/server.log


#########################################
##          SET PERMISSIONS            ##
#########################################
# create a "docker" user
useradd -U docker

# set proper permissions
usermod -aG audio docker
chown -R docker:docker \
	/config
chown docker:docker \
	/music \
	/playlist

