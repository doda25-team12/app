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

# Copy the jar created in the build stage
COPY --from=build /app/target/*.jar app.jar

# Set environment variables with defaults
ENV APP_PORT=8080
ENV MODEL_SERVICE_URL=""

# Expose Spring Boot default port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
    