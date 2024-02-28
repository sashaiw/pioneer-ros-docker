# FROM ubuntu:focal
FROM ros:noetic-ros-core

SHELL ["/bin/bash", "-c"]

# # setup timezone
# RUN echo 'Etc/UTC' > /etc/timezone && \
#     ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
#     apt-get update && \
#     apt-get install -q -y --no-install-recommends tzdata && \
#     rm -rf /var/lib/apt/lists/*

# # install packages
# RUN apt-get update && apt-get install -q -y --no-install-recommends \
#     dirmngr \
#     gnupg2 \
#     && rm -rf /var/lib/apt/lists/*

# # setup keys
# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# # setup sources.list
# RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros1-latest.list

# # setup environment
# ENV LANG C.UTF-8
# ENV LC_ALL C.UTF-8

# ENV ROS_DISTRO noetic

# install ros packages
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     build-essential \
#     ros-noetic-ros-core=1.5.0-1* \
#     python3-catkin-tools \
#     && rm -rf /var/lib/apt/lists/*


# setup entrypoint
COPY ./ros_entrypoint.sh /
RUN chmod +x /ros_entrypoint.sh

# build pioneer stuff
WORKDIR /catkin_ws
COPY ./src ./src

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-rosdep \
    python3-catkin-tools \
    build-essential \
    && rosdep init && rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/*

RUN source /opt/ros/noetic/setup.bash \
    && catkin init && catkin build

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
# CMD ["roslaunch", "pioneer_bringup", "pioneer_bringup_amazon.launch"]