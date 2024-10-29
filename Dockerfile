# Use the official Tomcat image as the base image
FROM tomcat:9.0-jdk15

# Copy the WAR file into Tomcat's webapps directory
COPY SWE645.war /usr/local/tomcat/webapps/


