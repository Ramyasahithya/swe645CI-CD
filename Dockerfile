FROM nginx:alpine

COPY form.html /usr/share/nginx/html/
COPY form.css /usr/share/nginx/html/

EXPOSE 80