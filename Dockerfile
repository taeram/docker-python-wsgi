FROM tiangolo/uwsgi-nginx-flask:python2.7

ENV FLASK_ENV production

WORKDIR /app
COPY ./ /app

# Pass in the forwarded_for header
RUN echo "\n\
uwsgi_param  FORWARDED_FOR      \$proxy_add_x_forwarded_for;\n\
" >> /etc/nginx/uwsgi_params

RUN pip install -r requirements.txt
