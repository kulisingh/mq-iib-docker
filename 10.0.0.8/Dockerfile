﻿# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

# User MQ Image as the base for to put IIB on top so we have both
FROM ibmcom/mq:latest

MAINTAINER Sam Rogers srogers@uk.ibm.com

# Fix locale warning
RUN echo 'LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8' >> /etc/environment

# Install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Install sudo 
RUN apt-get update && \
    apt-get install -y sudo && \
    rm -rf /var/lib/apt/lists/*

# Install rsyslog
RUN apt-get update && \
    apt-get install -y rsyslog && \
    rm -rf /var/lib/apt/lists/*

# Install supervisord
RUN apt-get update && \
    apt-get install -y supervisor && \
    rm -rf /var/lib/apt/lists/*

# Install IIB V10 Developer edition
RUN mkdir /opt/ibm && \
    curl http://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/integration/10.0.0.8-IIB-LINUX64-DEVELOPER.tar.gz \
    | tar zx --exclude iib-10.0.0.8/tools --directory /opt/ibm && \
    /opt/ibm/iib-10.0.0.8/iib make registry global accept license silently

# Configure system
COPY kernel_settings.sh /tmp/

# Copy over supervisor file to run mq and iib scripts for entrypoint
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN echo "IIB_10:" > /etc/debian_chroot  && \
    touch /var/log/syslog && \
    chown syslog:adm /var/log/syslog && \
    chmod +x /tmp/kernel_settings.sh;sync && \
    /tmp/kernel_settings.sh


# Create user to run as
RUN useradd --create-home --home-dir /home/iibuser -G mqbrkrs,mqm,sudo iibuser && \
    sed -e 's/^%sudo	.*/%sudo	ALL=NOPASSWD:ALL/g' -i /etc/sudoers
    
# Increase security
RUN sed -i 's/sha512/sha512 minlen=8/'  /etc/pam.d/common-password && \
    sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t1/'  /etc/login.defs && \
    sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/'  /etc/login.defs

# Copy in script files
COPY .iibuser_profile /home/iibuser/.profile
COPY iib_manage.sh /usr/local/bin
COPY iib-license-check.sh /usr/local/bin/
COPY iib_env.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/*.sh



# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/usr/local/bin/iib_env.sh

# Expose default admin port and http port
EXPOSE 4414 7800

# Set entrypoint to run mq scripts and iib management script
# ENTRYPOINT ["/usr/bin/supervisord"]
ENTRYPOINT ["/usr/bin/supervisord"]
