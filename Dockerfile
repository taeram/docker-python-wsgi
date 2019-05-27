FROM tiangolo/uwsgi-nginx-flask:python2.7

ENV FLASK_ENV production

WORKDIR /app
COPY ./ /app

RUN pip install -r requirements.txt
