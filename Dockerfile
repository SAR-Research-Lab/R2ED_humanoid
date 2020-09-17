FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone and locale to spanish and America/Bogota timezone. Change locale and timezone to whatever you want
ENV LANG="en_US.UTF-8"
ENV LANGUAGE=en_US

# Goto https://www.nomachine.com/download/download&id=10 and change for the latest NOMACHINE_PACKAGE_NAME and MD5 shown in that link to get the latest version.
ENV NOMACHINE_PACKAGE_NAME nomachine_6.11.2_1_amd64.deb
ENV NOMACHINE_BUILD 6.11
ENV NOMACHINE_MD5 d268d38823489c9b3cffd5d618c05b22

ENV USER user

RUN apt-get clean && apt-get update && apt-get install -y locales && \
    locale-gen en_US.UTF-8 && locale-gen en_US && \
    echo "America/New_York" > /etc/timezone && \
    apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG.UTF-8 UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG && \
    apt-get update -y && \
    apt-get install -y software-properties-common sudo && \
    add-apt-repository universe && \
    apt-get update -y
    
RUN apt-get install -y xterm pulseaudio cups curl \
    libgconf2-4 iputils-ping libnss3* libxss1 wget xdg-utils libpango1.0-0 fonts-liberation \
    mate-desktop-environment-extras firefox htop nano git vim
    
RUN curl -fSL "http://download.nomachine.com/download/${NOMACHINE_BUILD}/Linux/${NOMACHINE_PACKAGE_NAME}" -o nomachine.deb \
&& echo "${NOMACHINE_MD5} *nomachine.deb" | md5sum -c - && dpkg -i nomachine.deb && sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg

WORKDIR /home/user

#Install ROS
RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    sudo apt update

RUN sudo apt install ros-melodic-desktop-full python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential python-rosdep -y
RUN echo "source /opt/ros/melodic/setup.bash" >> /home/user/.bashrc

RUN sudo apt-get install -y git ros-melodic-libntcan ros-melodic-libpcan       \
        ros-melodic-controller-manager ros-melodic-controller-manager-msgs \
        ros-melodic-joint-limits-interface ros-melodic-cob-srvs ros-melodic-srdfdom            \
        ros-melodic-cob-control-mode-adapter ros-melodic-cob-dashboard ros-melodic-moveit*    \
        ros-melodic-cob-command-gui libmuparser-dev python-rosinstall openjdk-8-jdk     \
        python-wstool ros-melodic-gazebo-ros-pkgs ros-melodic-gazebo-ros-control

#ENV DEBIAN_FRONTEND=noninteractive 
RUN sudo apt install -y apt-utils
COPY ./keyboard .
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN sudo apt-get install keyboard-configuration < keyboard
RUN DEBIAN_FRONTEND=noninteractive sudo apt update && sudo apt install -y xvfb xserver-xorg xserver-xorg-video-fbdev xinit pciutils xinput xfonts-100dpi xfonts-75dpi xfonts-scalable
#RUN sudo apt install xfce4 dbus-x11 xfce4-goodies -y
RUN apt-get update && apt-mark hold iptables && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      dbus-x11 \
      psmisc \
      xdg-utils \
      x11-xserver-utils \
      x11-utils && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      xfce4 && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      gtk3-engines-xfce \
      libgtk-3-bin \
      libpulse0 \
      mousepad \
      xfce4-notifyd \
      xfce4-taskmanager \
      xfce4-terminal && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      xfce4-battery-plugin \
      xfce4-clipman-plugin \
      xfce4-cpufreq-plugin \
      xfce4-cpugraph-plugin \
      xfce4-diskperf-plugin \
      xfce4-datetime-plugin \
      xfce4-fsguard-plugin \
      xfce4-genmon-plugin \
      xfce4-indicator-plugin \
      xfce4-netload-plugin \
      xfce4-notes-plugin \
      xfce4-places-plugin \
      xfce4-sensors-plugin \
      xfce4-smartbookmark-plugin \
      xfce4-systemload-plugin \
      xfce4-timer-plugin \
      xfce4-verve-plugin \
      xfce4-weather-plugin \
      xfce4-whiskermenu-plugin && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libxv1 \
      mesa-utils \
      mesa-utils-extra && \
    sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

SHELL ["/bin/bash", "-c"]

RUN mkdir /home/user -p
WORKDIR /home/user

RUN source /opt/ros/melodic/setup.bash && cd /home/user && mkdir /home/user/catkin_ws/src/humanoid -p && cd /home/user/catkin_ws/src && catkin_init_workspace
COPY . /home/user/catkin_ws/src/humanoid
COPY nomachine_key /home/user/.ssh
COPY nomachine_key.pub /home/user/.ssh

COPY start_container.sh /home/user
COPY start_sim.desktop /home/user

#RUN sed -e "s/Authentication password//g" -i /usr/NX/etc/server.cfg
RUN echo "root:root" | chpasswd
#RUN echo "user:password" | sudo chpasswd

RUN mkdir /home/user/.config/autostart -p && mv /home/user/start_sim.desktop /home/user/.config/autostart/

ENTRYPOINT [ "/home/user/start_container.sh" ]



