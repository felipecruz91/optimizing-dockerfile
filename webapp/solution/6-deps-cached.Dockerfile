FROM maven:3.6.3-jdk-11-slim

# set workdir
WORKDIR /app

# copy the Project Object Model file
COPY ./pom.xml ./pom.xml

# fetch all dependencies and plugins based on the pom file
RUN mvn dependency:go-offline

# copy your other files
COPY ./src ./src

# build
RUN mvn package && cp target/*.jar ./app.jar

# expose port
EXPOSE 8080

# set the startup command to run your binary
CMD ["java", "-jar", "app.jar"]