FROM nginx:alpine 

RUN apk update && \
    apk add git

ADD https://file-examples.com/wp-content/uploads/2017/02/zip_10MB.zip .

COPY index.html usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]