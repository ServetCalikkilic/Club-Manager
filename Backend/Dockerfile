# 1. Aşama: Build (Maven ile projeyi derliyoruz)
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY . .
# Testleri atlayarak build alıyoruz (hata riskini azaltır)
RUN mvn clean package -DskipTests

# 2. Aşama: Run (Sadece çalışacak dosyayı alıyoruz, boyutu küçültür)
FROM openjdk:17-jdk-slim
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
