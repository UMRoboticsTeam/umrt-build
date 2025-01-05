FROM ros:humble-ros-base

RUN echo "deb [arch=amd64] https://raw.githubusercontent.com/UMRoboticsTeam/umrt-apt-repo/main/ humble main" > /etc/apt/sources.list.d/umrt_source.list


RUN sudo apt update && sudo apt install -y \
    ros-humble-ros2-control \
	ros-humble-ros2-controllers \
	gdb \
	gdbserver \
	libboost-all-dev \
    ros-humble-xacro \
    less \
    python3-curtsies \
    python-is-python3 \
    python3-bloom \
    fakeroot \
    dpkg-dev \
    debhelper \
 && rm -rf /var/lib/apt/lists/*

RUN sudo rm -f /etc/apt/sources.list.d/umrt_source.list