# ------------------------------
# 1 - Build stage (compile JAR)
# ------------------------------
FROM maven:3.9.11-eclipse-temurin-25 AS build
WORKDIR /app

# Accept GitHub credentials as build arguments
ARG GITHUB_ACTOR
ARG GITHUB_TOKEN

# Create Maven settings.xml with GitHub authentication
RUN mkdir -p /root/.m2 && \
    echo '<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" \
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" \
             xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 \
             http://maven.apache.org/xsd/settings-1.0.0.xsd"> \
            <servers> \
                <server> \
                    <id>github</id> \
                    <username>'"${GITHUB_ACTOR}"'</username> \
                    <password>'"${GITHUB_TOKEN}"'</password> \
                </server> \
            </servers> \
        </settings>' > /root/.m2/settings.xml

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
    