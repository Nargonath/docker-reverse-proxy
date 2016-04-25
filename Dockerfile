# Dockerfile for the apache reverse proxy container
FROM ubuntu:latest
MAINTAINER Nargonath

# build-variable given for the letsencrypt certification
ARG DOMAIN_NAME
ARG PRIVATE_IP
ARG PRIVATE_PORT

# checking that the variable was sent to the build command
RUN if [ -z ${DOMAIN_NAME} ]; then \
      exit 1; \
    elif [ -z ${PRIVATE_IP} ]; then \
      exit 2; \
    elif [ -z ${PRIVATE_PORT} ]; then \
      exit 3; \
    fi

RUN apt-get update && apt-get install -y \
  apache2 \
  git

# install apache2 needed modules
RUN a2enmod proxy \
    && a2enmod proxy_http \
    && service apache2 restart

# set the default file for proxy domain request
COPY myDomain.com.conf /etc/apache2/sites-available/

# replace the token inside sites-available conf with the build-arg
# source http://unix.stackexchange.com/questions/112023/how-can-i-replace-a-string-in-a-files
RUN cd /etc/apache2/sites-available/ \
    && mv myDomain.com.conf $DOMAIN_NAME".conf" \
    && sed -i -- "s/myDomain/${DOMAIN_NAME}/g" $DOMAIN_NAME".conf" \
    && sed -i -- "s/privateIP/${PRIVATE_IP}/g" $DOMAIN_NAME".conf" \
    && sed -i -- "s/privatePort/${PRIVATE_PORT}/g" $DOMAIN_NAME".conf"

# enable the just created virtualhost
RUN service apache2 start \
    && a2ensite ${DOMAIN_NAME}.conf \
    && service apache2 reload

RUN git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

# add the cron job to renew letsencrypt certificate
COPY letsencrypt-cron /etc/cron.d/

# create volume for let's encrypt
VOLUME /opt/letsencrypt

# exposing port for HTTP and HTTPS
# pretty much the same reason as VOLUME, -p does the port mapping/binding itself
#EXPOSE 80 443

# start apache
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
