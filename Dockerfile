# ---- Build stage: use Maven + JDK 17 to build the app ----
FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app

# Copy everything into the container
COPY . .

# Build the jar (skip tests to be faster)
RUN mvn -q -DskipTests package

# ---- Run stage: smaller image with just JDK ----
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app

# Copy the jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Spring Boot runs on 8080 inside the container
EXPOSE 8080

# Start the app
ENTRYPOINT ["java", "-jar", "app.jar"]
