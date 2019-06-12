FROM maven:3.6.1-jdk-8 AS build
WORKDIR /app
COPY pom.xml /app/pom.xml
RUN mvn dependency:go-offline
COPY src /app/src
RUN mvn package -DskipTests=true

FROM openjdk:8-jre-slim-stretch
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=mysql", "app.jar"]
