podman run -it --rm -p 12000:80 --volume ./:/usr/source --workdir /usr/source --name scala_sbt my-scala:1 /bin/bash
