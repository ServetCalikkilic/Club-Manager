# 1. Aşama: Build (Maven ve JDK 23 ile derleme)
# 'eclipse-temurin' şu an en güvenilir Java dağıtımıdır
FROM maven:3.9-eclipse-temurin-23 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# 2. Aşama: Run (JDK 23 Runtime ile çalıştırma)
FROM eclipse-temurin:23-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
