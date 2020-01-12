FROM ubuntu:18.04

RUN apt-get update \
    && apt install -y default-jdk maven \
    && rm -rf /var/lib/apt/lists/*

ADD . /app

# set workdir
WORKDIR /app

# build
RUN mvn package && cp target/*.jar ./app.jar

# expose port
EXPOSE 8080

# set the startup command to run your binary
CMD ["java", "-jar", "app.jar"]