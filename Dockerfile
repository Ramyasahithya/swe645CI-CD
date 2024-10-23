FROM ubuntu
RUN apt-get update
RUN apt-get install -y nginx
COPY form.html /usr/share/nginx/html/
COPY form.css /usr/share/nginx/html/
EXPOSE 80
CMD ["echo","Image created"]