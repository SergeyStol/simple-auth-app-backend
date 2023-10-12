FROM openjdk:21-slim
LABEL authors="sstol"

WORKDIR app
ARG EXTRACTED=./extracted
COPY ${EXTRACTED}/dependencies/ ./
COPY ${EXTRACTED}/spring-boot-loader/ ./
COPY ${EXTRACTED}/snapshot-dependencies/ ./
COPY ${EXTRACTED}/application/ ./

EXPOSE 8081

ENTRYPOINT ["java","-noverify","-XX:TieredStopAtLevel=1","-Dspring.main.lazy-initialization=true","org.springframework.boot.loader.JarLauncher"]