
FROM openresty/openresty:1.25.3.1-2-alpine-fat
ARG NGINX_CSP_CONFIG_FILE
ARG NGINX_PF_CORS_CONFIG_FILE
ARG NGINX_CORS_CONFIG_FILE
ARG NGINX_CSRF_CONFIG_FILE
ENV NGINX_CSP_CONFIG_FILE=${NGINX_CSP_CONFIG_FILE} \
    NGINX_PF_CORS_CONFIG_FILE=${NGINX_PF_CORS_CONFIG_FILE} \
    NGINX_CORS_CONFIG_FILE=${NGINX_CORS_CONFIG_FILE} \
    NGINX_CSRF_CONFIG_FILE=${NGINX_CSRF_CONFIG_FILE} 
RUN apk update && apk add --no-cache \
    openrc \
    curl \
      bash \
      net-tools \
      tcpdump \
      vim

LABEL "org.opencontainers.image.vendor"="Layer8"
LABEL "org.opencontainers.image.title"="Browser Security Training"
LABEL "org.opencontainers.image.authors"="info@layer8.cloud"
LABEL "org.opencontainers.image.source"="TBD"


########## Build the nginx.conf with CSP controls ##########
RUN set
COPY nginx/conf/mime.types /etc/nginx/mime.types
# during docker startup, run docker startup files
COPY nginx/entrypoint/ /docker-entrypoint.d/
COPY nginx/entrypoint/docker-entrypoint.sh /docker-entrypoint.sh
RUN  rm -f entrypoint/docker-entrypoint.sh && \
     chmod +x /docker-entrypoint.sh && \
     chmod +x /docker-entrypoint.d/*.sh
# copy the nginx config file
COPY nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/
COPY nginx/pubkey/* /usr/local/openresty/nginx/
# clear the dynamic config file out in case it was left over from a previous run
RUN bash -c ' \
    CONFIG_FILES=( \
        "${NGINX_CSP_CONFIG_FILE}" \
        "${NGINX_PF_CORS_CONFIG_FILE}" \
        "${NGINX_CORS_CONFIG_FILE}" \
        "${NGINX_CSRF_CONFIG_FILE}" \
    ); \
    echo "#!/bin/sh" > /docker-entrypoint.d/10-clear-csp-policy.sh; \
    for CONFIG_FILE in "${CONFIG_FILES[@]}"; do \
        echo "echo \"\" > ${CONFIG_FILE}; chmod a+rw ${CONFIG_FILE}" >> /docker-entrypoint.d/10-clear-csp-policy.sh; \
    done; \
    chmod a+x /docker-entrypoint.d/10-clear-csp-policy.sh; \
    # start a cron job to reload nginx every 5 seconds \
    echo "while sleep 5; do /usr/local/openresty/nginx/sbin/nginx -s reload &> /tmp/ngxreload   ; done &" > /docker-entrypoint.d/50-start-cron.sh; \
    chmod a+x /docker-entrypoint.d/50-start-cron.sh;    '

    # copy front end static files to the web root
COPY fe/ /usr/local/openresty/nginx/html/
# install luafilesystem which allow LUA to make file
# system calls like chdir, mode, default dir
RUN  luarocks install luafilesystem
CMD ["/docker-entrypoint.sh", "nginx"]
