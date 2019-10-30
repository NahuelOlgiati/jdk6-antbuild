FROM alpine:3.10

MAINTAINER Nahuel Olgiati <nahuel.olgiati@tallion.com>

ENV LANG=C.UTF-8

#Install glibc
ENV GLIBC_VERSION=2.30-r0
RUN apk --no-cache add ca-certificates wget
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk
RUN apk add glibc-${GLIBC_VERSION}.apk

#Install JDK 1.6
COPY lib/jdk-6u45-linux-x64.bin /usr/local/jdk-6u45-linux-x64.bin
RUN  chmod +x /usr/local/jdk-6u45-linux-x64.bin
RUN cd /usr/local && ./jdk-6u45-linux-x64.bin
RUN rm -f /usr/local/jdk-6u45-linux-x64.bin
ENV JAVA_HOME=/usr/local/jdk1.6.0_45

#Install Ant
RUN mkdir -p /opt/ant/
COPY lib/apache-ant-1.9.8-bin.tar.gz /opt/ant/apache-ant-1.9.8-bin.tar.gz
RUN tar -xvzf /opt/ant/apache-ant-1.9.8-bin.tar.gz -C /opt/ant/
RUN rm -f /opt/ant/apache-ant-1.9.8-bin.tar.gz
COPY lib/sonar-ant-task-2.3.jar /opt/ant/apache-ant-1.9.8/lib/sonar-ant-task-2.3.jar
ENV ANT_HOME=/opt/ant/apache-ant-1.9.8
ENV ANT_OPTS="-Xms256M -Xmx512M"

#Updating Path
ENV PATH="${PATH}:${HOME}/bin:${ANT_HOME}/bin:${JAVA_HOME}/bin"

VOLUME /home/proy
ENV ANT_FILE=build.xml

CMD ant -buildfile /home/proy/${ANT_FILE}
