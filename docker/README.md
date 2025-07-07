# Docker Cheatsheet

## Dockerfile

**FROM**

**ADD** <local> <image_path>

**CMD** ["/path/to/bin/", "arg1", "arg2"]

## Build
`docker built -t <image>:<tag> .`

## Run
`docker run --rm -it <image>:<tag>`

* __--rm__ removes image from system on exit
* __-it__ drops to interactive session

