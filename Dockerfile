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
        python3-pip \
        python3-doxypypy \
        fakeroot \
        dpkg-dev \
        debhelper \
        doxygen \
        doxygen-awesome-css \
        libi2c-dev \
        ffmpeg \
        libopenblas-dev \
        ros-humble-ros2-socketcan \
        ros-humble-ros2-control \
        ros-humble-ros2-controllers \
        ros-humble-moveit \
        ros-humble-foxglove-msgs \
        ros-humble-foxglove-compressed-video-transport \
        ros-humble-depthai-v3 \
        ros-humble-depthai-ros-msgs-v3 \
        ros-humble-depthai-bridge-v3 \
        ros-humble-depthai-descriptions \
        ros-humble-vision-msgs \
        ros-humble-depth-image-proc \
        ros-humble-xacro \
        ros-humble-rmw-fastrtps-cpp \
        ros-humble-v4l2-camera \
        ros-humble-image-transport \
        ros-humble-image-transport-plugins \
        ros-humble-ffmpeg-image-transport \
        ros-humble-ffmpeg-image-transport-msgs \
        ros-humble-joint-state-publisher \
        ros-humble-aruco-opencv \
        openframeworksarduino=0.0.3 \
        umrt-imu-interface=0.0.5 \
        umrt-geiger-interface=0.1.3 \
        umrt-arm-firmware-lib=0.5.0 \
        ros-humble-umrt-project-perry-description=0.0.9-0jammy \
        umrt-arm-encoder-driver=2.0.0 \
    && rm -rf /var/lib/apt/lists/*

RUN sudo pip3 install cantools

COPY . /ws

RUN cd /ws/src && ./build_scripts.sh

RUN sudo rm -rf /src

RUN sudo rm -f /etc/apt/sources.list.d/umrt_source.list
