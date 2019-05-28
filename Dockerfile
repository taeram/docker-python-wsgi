FROM tiangolo/uwsgi-nginx-flask:python2.7

ARG BUILD_DATE
LABEL build_version="RadPenguin Build-date:- ${BUILD_DATE}"

ENV FLASK_ENV production

WORKDIR /app
COPY ./ /app

RUN pip install -r requirements.txt
