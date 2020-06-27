# WIP
This repo is currently work in progress.  Last touched 27 June 2020
Updated Mono and gecko wine bits to later versions.

# docker-farming-simulator-server
This is a docker image to run the Farming Simulator 19 in a docker container.
The game files are **not** included and must be mounted into the container.

# Example

```
$ docker run -p 8080:80 -v "${PWD}/data:/app/drive_c/Program Files (x86)/Farming Simulator 2019" smearieryeti/farming-simulator-server
```
