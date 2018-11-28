FROM openshift/jenkins-slave-base-centos7

MAINTAINER Antti Rahikainen (antti.rahikainen@iki.fi)

# To find which package provides missing dependency, for example libXss.so
#   yum whatprovides libXss*
# and then install displayed answer like
#   yum install -y libXScrnSaver*


LABEL LABEL com.redhat.component="jenkins-agent-nodejs-8-rhel7-container" \
      name="openshift3/jenkins-agent-nodejs-8-rhel7" \
      version="3.6" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Nodejs" \
      io.k8s.description="The jenkins agent nodejs image has the nodejs tools on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,agent,cypress-io"

ENV NODEJS_VERSION=8 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH:/opt/rh/rh-nodejs8/root/usr/bin \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

RUN yum install -y centos-release-scl-rh && \
    INSTALL_PKGS="rh-nodejs${NODEJS_VERSION} rh-nodejs${NODEJS_VERSION}-npm rh-nodejs${NODEJS_VERSION}-nodejs-nodemon make gcc-c++" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Install dependencies
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


RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001

RUN scl enable rh-nodejs8 sh

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001