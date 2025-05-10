# 建立階段
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY .mvn/ .mvn/
# COPY mvnw . ← 可以整行刪掉了
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package spring-boot:repackage -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]

