FROM python:3.7

ENV GUROBI_INSTALL /opt/gurobi
ENV GUROBI_HOME $GUROBI_INSTALL/linux64
ENV PATH $PATH:$GUROBI_HOME/bin
ENV LD_LIBRARY_PATH $GUROBI_HOME/lib

ARG GUROBI_MAJOR_VERSION=8.1
ARG GUROBI_VERSION=8.1.1
ARG user=gurobi
ARG group=gurobi
ARG uid=1000
ARG gid=1000

RUN apt-get update && apt-get upgrade && \
    apt-get install         \
      bash                  \
      ca-certificates       \
      gzip                  \
      curl                  \
      wget
      
# Add user
RUN addgroup --gid ${gid} ${group}

RUN adduser --home /home/gurobi --uid ${uid} --ingroup ${group} --shell /bin/bash  ${user}
    
# Install latest glibc
ENV GLIBC_VERSION=2.30-r0
RUN apt-get install ca-certificates
# RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub                                   && \
#    wget -P /tmp https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk       && \
#    wget -P /tmp https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk   && \
#    wget -P /tmp https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk
#RUN apk add /tmp/glibc-${GLIBC_VERSION}.apk /tmp/glibc-bin-${GLIBC_VERSION}.apk /tmp/glibc-i18n-${GLIBC_VERSION}.apk              && \
#    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8
    
# Install gurobi
RUN mkdir -p ${GUROBI_INSTALL}                                                                                      && \
    wget -P /home/gurobi/ http://packages.gurobi.com/${GUROBI_MAJOR_VERSION}/gurobi${GUROBI_VERSION}_linux64.tar.gz && \
    tar xvfz /home/gurobi/gurobi${GUROBI_VERSION}_linux64.tar.gz                                                    && \
    mv /gurobi811/linux64/ ${GUROBI_INSTALL}
    
# Clean up
RUN rm -rf ${GUROBI_HOME}/docs                             && \
    rm -rf ${GUROBI_HOME}/examples                         && \
    rm -rf ${GUROBI_HOME}/src                              && \
    rm -rf /var/cache/apk/*                                && \
    rm -rf /tmp/*                                          && \
    rm -rf /var/log/*                                      && \
    rm -rf /gurobi811                                      && \
    rm /home/gurobi/gurobi${GUROBI_VERSION}_linux64.tar.gz
    
# We try to eliminate the Python 2.7 binary and the shell script
# requiring it
RUN rm ${GUROBI_HOME}/bin/python2.7                        && \
    rm ${GUROBI_HOME}/bin/gurobi.sh

# Add our custom gurobi.sh
# this basically copies from the original but replaces the 
# usage of the Python 2.7 binary shipped WITH gurobi 
COPY scripts/gurobi.sh ${GUROBI_HOME}/bin

COPY scripts/setup.py ${GUROBI_HOME}

COPY scripts/docker-entrypoint.sh ${GUROBI_HOME}/bin

# Set permissions
RUN chown -R gurobi ${GUROBI_HOME} && \
    chmod 755 ${GUROBI_HOME}/bin/docker-entrypoint.sh

WORKDIR $GUROBI_HOME

RUN python3 setup.py install

USER gurobi

WORKDIR /usr/src/gurobi/scripts

VOLUME /usr/src/gurobi/scripts
VOLUME /home/gurobi

ENTRYPOINT ["docker-entrypoint.sh"]
