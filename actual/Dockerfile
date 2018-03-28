# Start from base image with Java 8
FROM openjdk:8-jre-alpine

# Set the work directory
WORKDIR /io/actual/

COPY target/java-tracing-1.0-SNAPSHOT.jar ./lib/java-tracing-1.0-SNAPSHOT.jar

#ENTRYPOINT ["java", "-jar", "./lib/java-tracing-1.0-SNAPSHOT.jar"]

#docker build -t actual .
#docker run -d -p 8080:8080 actual sh