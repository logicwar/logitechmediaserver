[appurl]: https://downloads.slimdevices.com/LogitechMediaServer_v8.1.1/
[hub]: https://hub.docker.com/r/logicwar/logitechmediaserver/
[lms_wikipedia]: https://en.wikipedia.org/wiki/Logitech_Media_Server
[wiki]: http://wiki.slimdevices.com/index.php/Logitech_Media_Server
[tz_wikipedia]:https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

# [Docker Container for Logitech Media Server][hub]

This is a Docker image based on phusion/baseimage for running the latest Logitech Media Server [8.1.1 build][appurl].

Logitech Media Server (formerly SlimServer, SqueezeCenter and Squeezebox Server) is a streaming audio server supported by Logitech (formerly Slim Devices), developed in particular to support their Squeezebox range of digital audio receivers. [Wikipedia][lms_wikipedia] / [Official Squeezebox site][wiki]

Logitech Media Server is free software, released under the terms of the GNU General Public License.

## Usage

```
docker create --name=lms \ 
              -v <path to config>:/config \
              -v <path to music>:/music:ro \
              -v <path to playlist>:/playlist:ro \
              -e PGID=<gid>
              -e PUID=<uid> \
              -e TZ=<timezone> \
              -p 9000:9000 \
              -p 3483:3483 \
              -p 3483:3483/udp \
              logicwar/logitechmediaserver
```
## Parameters

* `-p 9000` - port for the Web interface and streaming to Squeezebox players.
* `-p 3483` - port for the control channel of the Squeezeboxes (display, IR, etc.)
* `-p 3483/upd`- port for the control and streaming to the old SLIMP3 players
* `-v /config` - where LMS stores config and log files
* `-v /music` - local path for your audios
* `-v /playlist` - local path for your playlists
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for timezone information : Europe/London, Europe/Zurich, America/New_York, ... ([List of TZ][tz_wikipedia])

For shell access while the container is running do `docker exec -it lms /bin/bash`

### User / Group ID

For security reasons and to avoid permissions issues with data volumes (`-v` flags), you may want to create a specific "docker" user with proper right accesses on your persistant folders. To find your user **uid** and **gid** you can use the `id <user>` command as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

and finally specify your "docker" user `PUID` and group `PGID`. In this exemple `PUID=1001` and `PGID=1001`.

## Setting up the application 

The intitial setup is made by browsing to http://your_server_IP:9000 and begin configuring the Logitech Media Server.

## Upgrading the Logitech Media Server

As new releases of LMS are produced. you may not want to wait for a new Docker version to be build. If a new version of LMS is available, it will tell you so in the status bar on the main Web GUI page.

Click on the upgrade link which will take you to the LMS updates page. Alternatively, you can go to Settings->Advanced->Software Updates and click on `Check for updates now`. Here you should click on the "Click here for further information" which moves you onward to the information page which will give you a step by step guide on what to do. Please note that LMS will have already started to download the deb package in the background.

To follow the instruction of the information page, you will need to open a terminal session on your running docker container: `docker exec -it lms /bin/bash`. When all steps have been followed you will need to stop and restart the container.

## Versions
+ **V0.4** Updated with 8.1.1 - 1610364019 and phusion/baseimage focal-1.0.0
+ **V0.3** Updated with 7.9.2-1545144292
+ **V0.2** Updated with 7.9.1-1517314665
+ **V0.1** Initial Release 7.9.1-1516947667
