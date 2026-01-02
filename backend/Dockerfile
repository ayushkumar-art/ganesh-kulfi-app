FROM openjdk:21-jdk-slim

LABEL maintainer="Ganesh Kulfi Team"
LABEL description="Ganesh Kulfi Backend - Production Ready"

WORKDIR /app

# Copy the fat JAR
COPY build/libs/ganeshkulfi-backend-all.jar app.jar

# Create uploads directory
RUN mkdir -p uploads

# Expose application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Run the application
CMD ["java", "-Xms256m", "-Xmx512m", "-jar", "app.jar"]
