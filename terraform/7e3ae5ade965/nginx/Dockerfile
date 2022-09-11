ARG ECR_NGINX_URI=nginx:1.23
FROM $ECR_NGINX_URI

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/web.conf /etc/nginx/conf.d/default.conf

COPY ./public /workspace/nginx/public

EXPOSE 80
