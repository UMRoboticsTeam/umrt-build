# UMRT Build Image

This repository contains a Docker image used to build packages for the University of Manitoba Robotics Team.
This image is intended to be used for all development work to ensure that the CI/CD system has all the dependencies needed to successfully build a package.

## How to use 

1. Generate a *Personal Access Token* for your GitHub account
   1. In the upper-right corner of any page on GitHub, click your profile photo, then click `Settings`
   2. In the left sidebar, click `Developer settings`
   3. In the left sidebar, under `Personal access tokens`, click `Tokens (classic)`
   4. Click `Generate new token (classic)` at the top of the page
      1. Give your token a nice name, e.g. "UMRT Docker auth token"
      2. Set expiration to a reasonable date sometime between now and your expected graduation
      3. Check `read:packages`, and leave the rest unchecked
      4. Click Generate token
   5. You should now see a bunch of letters/numbers starting with `ghp_`, this is your token
   6. Save the token somewhere safe, once you leave this page you will never be able to see it again
2. Set up Docker authentication 
   1. Open a terminal and type, `docker login ghcr.io`
   2. Enter your GitHub username, and instead of password paste your token
   3. You should now be able to download UMRT Docker images!
3. Test by running `docker pull ghcr.io/umroboticsteam/umrt-build` to download the latest image

## Dev image

This repository also builds a second image called `umrt-build-dev`.
This is another layer on top of umrt-build which adds SSH access and rsync.
The intent of this image is to make it easier to use umrt-build as a remote host toolchain with CLion, or other IDEs with similar remote development functionality.
As well, it could be used for testing on the rover over SSH instead of needing to develop on the actual rover computer.
Speak to someone on the team for the credentials.

## Launching the image

Assuming your workspace is located at `~/workspace` and you would like to access the container through SSH on port `12345`, my preferred command to start a container is:  
`docker run --rm -it --name umrt-arm -v "~/workspace":/workspace -p 12345:22 --pull=always ghcr.io/umroboticsteam/umrt-build-dev:main`  
This always checks for and downloads the latest image before starting.
If a specific version is wanted, such as `v0.0.20`, simply change `umrt-build-dev:main` to `umrt-build-dev:v0.0.20`.
