FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install apt-utils lsb-release curl gnupg2 tzdata -y

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add - && \
    apt update && apt install -y ros-melodic-desktop-full

WORKDIR /usr/src/catkin_ws

COPY ./humanoid_description /usr/src/catkin_ws/src/humanoid
COPY ./humanoid_description /usr/src/catkin_ws/src/humanoid
COPY ./schunk_lwa4p_svh /usr/src/catkin_ws/src/humanoid
COPY ./schunk_lwa4p_svh_moveit_config /usr/src/catkin_ws/src/humanoid
COPY ./schunk_robots /usr/src/catkin_ws/src/humanoid
COPY ./simulation /usr/src/catkin_ws/src/humanoid
COPY ./.git /usr/src/catkin_ws/src/humanoid
COPY ./docker_entrypoint.sh /usr/src/catkin_ws

RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

RUN bash -c "source /opt/ros/melodic/setup.bash && cd src && catkin_init_workspace && cd .. && catkin_make"

#CMD while : ; do echo "${MESSAGE=Idling...}"; sleep ${INTERVAL=600}; done
ENTRYPOINT bash /usr/src/catkin_ws/docker_entrypoint.sh