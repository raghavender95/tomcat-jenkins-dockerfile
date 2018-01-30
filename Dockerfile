FROM ubuntu:latest
ENV JENKINS_HOME /var/jenkins_home

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/vloume from a data container,
# ensure you use same uid
RUN useradd -d "$JENKINS_HOME" -u 1000 -m -s /bin/bash jenkins
mkdir ~/container-data

# Jenkins home directoy is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home
RUN groupadd docker && gpasswd -a jenkins docker && gpasswd -a jenkins root
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install openjdk-8-jdk wget
RUN mkdir /usr/local/tomcat
RUN wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.0.49/bin/apache-tomcat-8.0.49.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-8.0.49/* /usr/local/tomcat/


RUN wget http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war -O /usr/share/jenkins.war
RUN cp /usr/share/jenkins.war /usr/local/tomcat/webapps/jenkins.war
	
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run



