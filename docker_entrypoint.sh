#!/usr/bin/env bash

groupadd -r $USER -g 433 \
&& useradd -u 431 -r -g $USER -d /home/$USER -s /bin/bash -c "$USER" $USER \
&& adduser $USER sudo \
&& mkdir /home/$USER \
&& chown -R $USER:$USER /home/$USER \
&& echo $USER':'$PASSWORD | chpasswd
/etc/NX/nxserver --startup
tail -f /usr/NX/var/log/nxserver.log

roscore & 2>/dev/null 1>/dev/null
bash

<a href="javascript:void(0)" onclick="saveck('nomachine_6.10.12_1_amd64.deb','https://download.nomachine.com/download/6.10/Linux/nomachine_6.10.12_1_amd64.deb');">Download</a>