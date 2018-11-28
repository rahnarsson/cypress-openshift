FROM registry.access.redhat.com/openshift3/jenkins-agent-nodejs-8-rhel7

MAINTAINER Antti Rahikainen (antti.rahikainen@iki.fi)

# Install Cypress dependencies
USER root

RUN yum repolist

RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
RUN yum-config-manager --enable rhel-7-server-optional-rpms
RUN yum install -y xorg-x11-server-Xvfb
RUN yum install -y gtk2-2.24*
RUN yum install -y libXtst*
# provides libXss
RUN yum install -y libXScrnSaver*
# provides libgconf-2
RUN yum install -y GConf2*
# provides libasound
RUN yum install -y alsa-lib*
RUN yum install -y openssl

RUN yum clean all

