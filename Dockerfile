FROM openjdk:21-slim as build
LABEL authors="sstol"

WORKDIR /buildpath
COPY . .
RUN ./mvnw install
RUN java -Djarmode=layertools -jar target/simple-auth-app-backend-0.0.1-SNAPSHOT.jar extract --destination extracted/

FROM openjdk:21-slim
LABEL authors="sstol"

WORKDIR app
ARG EXTRACTED=/buildpath/extracted
COPY --from=build ${EXTRACTED}/dependencies/ ./
COPY --from=build ${EXTRACTED}/spring-boot-loader/ ./
COPY --from=build ${EXTRACTED}/snapshot-dependencies/ ./
COPY --from=build ${EXTRACTED}/application/ ./

ENTRYPOINT ["java","-noverify","-XX:TieredStopAtLevel=1","-Dspring.main.lazy-initialization=true","org.springframework.boot.loader.JarLauncher"]