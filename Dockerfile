FROM centos:7.9.2009

LABEL maintainer="MonkeyRay <admin@monkeyray.net>"

RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo \
&&  yum makecache fast \ 
&&  yum install -y patch \
        gcc \
        glibc-devel \
        make \
        openssl-devel \
        pcre-devel \
        zlib-devel \
        gd-devel \
        geoip-devel \
        perl-devel \
        git \
&&  groupadd -g 101 nginx \
&&  adduser -u 101 -d /var/cache/nginx -s /sbin/nologin -g nginx nginx \
&&  yum clean all \
&&  rm -rf /var/cache/*

ENV BUILD_DIR=/workdir \
    NGINX_VERSION=1.21.6 \
    PATCH_VERSION=102101

RUN mkdir -p ${BUILD_DIR} \
&&  cd ${BUILD_DIR} \
# Download packages
&&  curl -O http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
&&  git clone https://github.com/chobits/ngx_http_proxy_connect_module.git nginx_proxy \
&&  tar -zxf nginx-${NGINX_VERSION}.tar.gz \
&&  cd nginx-${NGINX_VERSION} \
# Configure and build nginx
&&  patch -p1 < /workdir/nginx_proxy/patch/proxy_connect_rewrite_${PATCH_VERSION}.patch \
&&  ./configure --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/client_temp \
        --http-proxy-temp-path=/var/cache/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-compat \
        --with-file-aio \
        --with-threads \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
        --with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
        --add-module=${BUILD_DIR}/nginx_proxy \
&&  make \
&&  make install \
# Clean build cache
&&  rm -rf ${BUILD_DIR}/nginx_proxy \
&&  rm -rf ${BUILD_DIR}/nginx-${NGINX_VERSION} \
&&  rm -f ${BUILD_DIR}/nginx-${NGINX_VERSION}.tar.gz \
&&  rmdir ${BUILD_DIR}

COPY --chown=nginx:nginx nginx.conf /etc/nginx/nginx.conf

WORKDIR /etc/nginx

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
