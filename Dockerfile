FROM tomcat:8.0.18-jre8
COPY target/maven-web-application.war maven-web-application.war
//COPY target/maven-web-application.war /usr/local/tomcat/webapps/maven-web-application.war
