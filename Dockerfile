FROM node:9.11 as NODE_ENVIRONMENT

WORKDIR /app
COPY ./ /app

# Compile our CSS and JavaScript assets
RUN [ -e package.json ] && npm install || true
RUN [ -e bower.json ] && ./node_modules/.bin/bower --allow-root install || true
RUN [ -e Gruntfile.js ] && ./node_modules/.bin/grunt || true

# Clean up
RUN rm -rf \
    /root/.npm \
    /tmp/* \
    /usr/src/* \
    /var/lib/apk/* \
    /var/tmp/* \
    /app/node_modules/

# -------------------------------------------------------------------------------------------------------------------- #
FROM tiangolo/uwsgi-nginx-flask:python2.7

ARG BUILD_DATE
LABEL build_version="RadPenguin Build-date:- ${BUILD_DATE}"

ENV FLASK_ENV production
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Configure the locale
RUN apt-get -qq update && apt-get -yqq install locales && \
    sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen && \
    echo 'LANG="$LANG"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG="$LANG"

WORKDIR /app

# Copy files from the NODE_ENVIRONMENT container above
COPY --from=NODE_ENVIRONMENT /app /app
RUN pip install -r requirements.txt

# Clean up
RUN rm -rf \
    /root/.cache \
    /tmp/*
