FROM nginx:latest

RUN sed -i 's/user  nginx;/user root;/' /etc/nginx/nginx.conf

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
