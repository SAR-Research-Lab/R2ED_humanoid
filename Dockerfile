FROM tiryoh/ros-desktop-vnc:melodic

ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone and locale to spanish and America/Bogota timezone. Change locale and timezone to whatever you want
ENV LANG="en_US.UTF-8"
ENV LANGUAGE=en_US

RUN apt update
RUN apt-get install -y git ros-melodic-libntcan ros-melodic-libpcan       \
        ros-melodic-controller-manager ros-melodic-controller-manager-msgs \
        ros-melodic-joint-limits-interface ros-melodic-cob-srvs ros-melodic-srdfdom            \
        ros-melodic-cob-control-mode-adapter ros-melodic-cob-dashboard ros-melodic-moveit*    \
        ros-melodic-cob-command-gui libmuparser-dev python-rosinstall openjdk-8-jdk     \
        python-wstool ros-melodic-gazebo-ros-pkgs ros-melodic-gazebo-ros-control 
        
RUN apt-get install -y ros-melodic-schunk-description ros-melodic-ridgeback-description \
        ros-melodic-ridgeback-simulator ros-melodic-ridgeback-desktop

SHELL ["/bin/bash", "-c"]

WORKDIR /home/ubuntu
RUN source /opt/ros/melodic/setup.bash && mkdir catkin_ws/src/humanoid -p && \
                cd catkin_ws/src && catkin_init_workspace && \
                cd .. && catkin_make 
WORKDIR catkin_ws/src/humanoid
COPY schunk_lwa4p_sdh schunk_lwa4p_sdh
#COPY schunk_lwa4p_sdh_moveit_config schunk_lwa4p_sdh_moveit_config
COPY schunk_lwa4p_svh schunk_lwa4p_svh
COPY schunk_lwa4p_svh_moveit_config schunk_lwa4p_svh_moveit_config
#COPY schunk_lwa4p_svh_moveit_config schunk_lwa4p_svh_moveit_config
COPY simulation simulation