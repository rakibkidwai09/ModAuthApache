FROM httpd:2.4

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libjansson-dev \
    libapache2-mod-auth-openidc \
    apache2-dev \
    build-essential \
    git \
    wget \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY oidc.conf /usr/local/apache2/conf/extra/oidc.conf

COPY oidc.env /etc/apache2/oidc.env

# Generate oidc.conf from template at container startup
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

RUN echo "Include conf/extra/oidc.conf" >> /usr/local/apache2/conf/httpd.conf

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["httpd-foreground"]