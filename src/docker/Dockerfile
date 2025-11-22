FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY target/*.jar app.jar
ENV PORT 8080
EXPOSE $PORT
ENTRYPOINT ["java","-jar","/app.jar"]