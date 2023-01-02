@echo off
REM create volume with 'podman volume create sbt_cache'
podman run -it --rm -p 12000:80 --volume ./:/usr/source --workdir /usr/source --mount type=volume,source=sbt_cache,target=/root/.cache/coursier --name scala_sbt my-scala:1 /bin/bash
