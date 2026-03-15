FROM httpd:2.4

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libjansson-dev \
    apache2-dev \
    libssl-dev \
    build-essential \
    git \
    wget \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY oidc.conf /usr/local/apache2/conf/extra/oidc.conf

COPY oidc.env /usr/local/apache2/conf/oidc.env

# Generate oidc.conf from template at container startup
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

RUN git clone https://github.com/OpenIDC/mod_auth_openidc.git \
    && cd mod_auth_openidc \
    && ./autogen.sh \
    && ./configure --with-apxs=/usr/local/apache2/bin/apxs \
    && make \
    && make install \
    && cd .. \
    && rm -rf mod_auth_openidc

RUN echo "Include conf/extra/oidc.conf" >> /usr/local/apache2/conf/httpd.conf

RUN echo "LoadModule auth_openidc_module modules/mod_auth_openidc.so" \
    >> /usr/local/apache2/conf/httpd.conf

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["httpd-foreground"]