# Usa la imagen de Maven como base
FROM maven:3.9.6-eclipse-temurin-17-focal AS builder

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de configuración de Maven
COPY pom.xml .

# Descarga las dependencias de Maven (esto separa la descarga de dependencias de la compilación para mejorar la velocidad de compilación)
RUN mvn dependency:go-offline

# Copia el resto de los archivos del proyecto
COPY src src

# Compila el proyecto
RUN mvn clean package -DskipTests

# Usa una imagen de Java para ejecutar la aplicación
FROM openjdk:17-jdk-slim

# Copia el archivo JAR compilado del contenedor de compilación al contenedor de ejecución
COPY --from=builder /app/target/crud-0.0.1-SNAPSHOT.jar java-app.jar

# Establece el comando de entrada para ejecutar el archivo JAR
ENTRYPOINT ["java", "-jar", "java-app.jar"]