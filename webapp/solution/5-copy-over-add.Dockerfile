FROM maven:3.6.3-jdk-11-slim

# set workdir
WORKDIR /app

# copy everything into /app
COPY . /app

# build
RUN mvn package && cp target/*.jar ./app.jar

# expose port
EXPOSE 8080

# set the startup command to run your binary
CMD ["java", "-jar", "app.jar"]