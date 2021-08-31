FROM arm64v8/nginx

COPY ./public /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

