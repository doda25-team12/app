# ------------------------------
# 1 - Build stage (compile JAR)
# ------------------------------
FROM maven:3.9.11-eclipse-temurin-25 AS build
WORKDIR /app

# Copy pom.xml and resolve dependencies first (better caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build the application JAR
RUN mvn clean package -DskipTests


# ------------------------------
# 2 - Runtime stage (run the app)
# ------------------------------
FROM eclipse-temurin:25-jre

WORKDIR /app

ENV MODEL_HOST=http://localhost:8080

# Copy the jar created in the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose Spring Boot default port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
    