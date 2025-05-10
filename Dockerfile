# 建立階段
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .                      # Layer 1
COPY .mvn .mvn                      # Layer 2
COPY mvnw .                         # Layer 3
RUN ./mvnw dependency:go-offline   # Layer 4 → 快取 Maven 依賴
COPY src ./src                     # Layer 5
RUN mvn clean package spring-boot:repackage -DskipTests # Layer 6 → 真正打包

# 運行階段
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java", "-jar", "app.jar"]
