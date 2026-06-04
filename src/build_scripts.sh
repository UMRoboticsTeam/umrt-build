#!/usr/bin/bash

# Compile and install umrt-can-definitions
cd umrt-can-definitions
cmake -B build/
cmake --build build/
cd build
cpack -G DEB

apt install -y ./output-packages/*.deb
cd ../
rm -r build
cd ../

