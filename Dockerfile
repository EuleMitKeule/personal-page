FROM nginx

COPY ./public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

