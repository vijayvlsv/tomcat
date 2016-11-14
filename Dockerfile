FROM ubuntu:14.04

MAINTAINER kevell 

ENV TOMCAT_VERSION 8.0.37

# Set locales
RUN locale-gen en_GB.UTF-8 
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh


RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common 

# java install

RUN 
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
add-apt-repository -y ppa:webupd8team/java && \
apt-get update && \
apt-get install -y oracle-java8-installer wget unzip tar && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/cache/oracle-jdk8-installer && \


ENV JAVA_HOME /usr/lib/jvm/java-8-oracle 


RUN wget --quiet --no-cookies http://apache.rediris.es/tomcat/tomcat-8/v${v8.0.38}/bin/apache-tomcat-${v8.0.38}.tar.gz -O /tmp/tomcat.tgz && \
tar xzvf /tmp/tomcat.tgz -C /opt && \
mv /opt/apache-tomcat-${v8.0.38} /opt/tomcat && \
rm /tmp/tomcat.tgz && \
rm -rf /opt/tomcat/webapps/examples && \
rm -rf /opt/tomcat/webapps/docs && \
rm -rf /opt/tomcat/webapps/ROOT && 

#install tomcatusers.xml

ADD tomcat-users.xml /opt/tomcat/conf/

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009
VOLUME "/opt/tomcat/webapps"
WORKDIR /opt/tomcat

# Launch Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
