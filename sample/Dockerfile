# Simple Dockerfile
##################################

# FROM nginx:alpine 

# RUN apk update && \
#     apk add git

# ADD https://file-examples.com/wp-content/uploads/2017/02/zip_10MB.zip .

# COPY index.html usr/share/nginx/html

# ENTRYPOINT ["nginx", "-g", "daemon off;"]

## Multi-stage Dockerfile
##################################

FROM alpine AS stage1

RUN apk update && \
    apk add git

ADD https://file-examples.com/wp-content/uploads/2017/02/zip_10MB.zip .

COPY index.html /opt/index.html

FROM nginx:alpine
COPY --from=stage1 /opt/index.html /usr/share/nginx/html/
ENTRYPOINT ["nginx", "-g", "daemon off;"]

## Run
##################################
# docker run -d --rm -p 80:80 my-nginx