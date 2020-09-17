#!/bin/sh
groupadd -r user -g 433 \
&& useradd -u 431 -r -g user -d /home/user -s /bin/bash -c "user" user \
&& adduser user sudo \
&& mkdir -p /home/user \
&& chown -R user:user /home/user \
#&& echo $USER && echo user':'password | sudo chpasswd
#Xvfb :0 -screen 0 1920x1080x24 &
startxfce4
#/etc/NX/nxserver --startup
bash
#tail -f /usr/NX/var/log/nxserver.log