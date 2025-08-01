FROM ros:humble-ros-base

RUN echo "deb [arch=amd64,arm64 signed-by=/etc/apt/keyrings/umrt.asc] https://raw.githubusercontent.com/UMRoboticsTeam/umrt-apt-repo/main/ humble main" > /etc/apt/sources.list.d/umrt_source.list

RUN --mount=type=secret,id=apt_auth_conf,target=/etc/apt/auth.conf.d/umrt.conf --mount=type=secret,id=apt_pubkey,target=/etc/apt/keyrings/umrt.asc,mode=0644 \
    sudo apt update && sudo apt install -y \
        gdb \
        gdbserver \
        libboost-all-dev \
        less \
        python3-curtsies \
        python-is-python3 \
        python3-bloom \
        fakeroot \
        dpkg-dev \
        debhelper \
        doxygen \
        python3-doxypypy \
        doxygen-awesome-css \
        ros-humble-ros2-socketcan \
        libopenblas-dev \
        ros-humble-ros2-control \
        ros-humble-ros2-controllers \
        ros-humble-moveit \
        ros-humble-foxglove-msgs \
        ros-humble-depthai \
        ros-humble-depthai-ros-msgs \
        ros-humble-depthai-bridge \
        ros-humble-depthai-descriptions \
        ros-humble-vision-msgs \
        ros-humble-depth-image-proc \
        ros-humble-xacro \
        openframeworksarduino=0.0.3 \
        umrt-arm-firmware-lib=0.4.0 \
        umrt-project-perry-config=0.0.6 \
    && rm -rf /var/lib/apt/lists/*

RUN sudo rm -f /etc/apt/sources.list.d/umrt_source.list
