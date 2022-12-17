FROM eclipse-temurin:19.0.1_10-jdk

RUN apt-get update
RUN apt-get -qq -y install \
    curl \
    unzip \
    zip

RUN curl -s "https://get.sdkman.io" | bash

RUN ["/bin/bash", "-c", "source /root/.sdkman/bin/sdkman-init.sh; sdk install gradle 7.6"]

