FROM tiryoh/ros-desktop-vnc:melodic

ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone and locale. Change locale and timezone to whatever you want
ENV LANG="en_US.UTF-8"
ENV LANGUAGE=en_US
# Above locale commands don't seem to work. Try to edit:
RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

RUN apt update
RUN apt-get install -y git ros-melodic-libntcan ros-melodic-libpcan       \
        ros-melodic-controller-manager ros-melodic-controller-manager-msgs \
        ros-melodic-joint-limits-interface ros-melodic-cob-srvs ros-melodic-srdfdom            \
        ros-melodic-cob-control-mode-adapter ros-melodic-cob-dashboard ros-melodic-moveit*    \
        ros-melodic-cob-command-gui libmuparser-dev python-rosinstall openjdk-8-jdk     \
        python-wstool ros-melodic-gazebo-ros-pkgs ros-melodic-gazebo-ros-control 
        
RUN apt-get install -y ros-melodic-schunk-description \
        ros-melodic-ridgeback-description ros-melodic-ridgeback-navigation \
        ros-melodic-ridgeback-simulator ros-melodic-ridgeback-desktop \
        ros-melodic-cob-cartesian-controller ros-melodic-cob-frame-tracker \
        ros-melodic-cob-gazebo-ros-control ros-melodic-cob-twist-controller

SHELL ["/bin/bash", "-c"]

WORKDIR /home/ubuntu/catkin_ws/src/humanoid
COPY schunk_lwa4p_sdh schunk_lwa4p_sdh
#COPY schunk_lwa4p_sdh_moveit_config schunk_lwa4p_sdh_moveit_config
COPY schunk_lwa4p_svh schunk_lwa4p_svh
COPY schunk_lwa4p_svh_moveit_config schunk_lwa4p_svh_moveit_config
#COPY schunk_lwa4p_svh_moveit_config schunk_lwa4p_svh_moveit_config
COPY simulation simulation

WORKDIR /home/ubuntu
RUN source /opt/ros/melodic/setup.bash && mkdir catkin_ws/src/humanoid -p && \
                cd catkin_ws/src && catkin_init_workspace && \
                cd .. && catkin_make 

RUN echo "source /home/ubuntu/catkin_ws/devel/setup.bash" >> .bashrc

CMD echo "docker run -p 6080:80 --shm-size=4096m sarlabdearborn/humanoid:full_gazebo"