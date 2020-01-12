FROM ubuntu

ADD . /app

RUN apt-get update
RUN apt install -y default-jdk maven

WORKDIR /app

# build
RUN mvn package && cp target/*.jar ./app.jar

# expose port
EXPOSE 8080

# set the startup command to run your binary
CMD ["java", "-jar", "app.jar"]