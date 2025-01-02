FROM ros:humble-ros-base

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