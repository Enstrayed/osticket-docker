FROM alpine

# Get required packages
RUN apk add php82 php82-common php82-mysqli php82-curl php82-fpm php82-session php82-imap php82-xml php82-xmlwriter php82-dom php82-phar php82-mbstring php82-intl php82-gd php82-iconv caddy mysql mariadb-client curl 

# Setup osTicket
RUN curl -OL $( curl -s https://api.github.com/repos/osTicket/osTicket/releases/latest | grep browser_download_url | cut -d '"' -f 4 )
RUN mkdir /var/www/
RUN unzip ./*.zip -d /var/www/
RUN rm -rf /var/www/upload/include/plugins

# Setup PHP
RUN mkdir /run/php
RUN touch /run/php/php-fpm.sock
COPY www.conf /etc/php82/php-fpm.d/www.conf

# Setup init
COPY inittab /etc/inittab
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Setup Caddy
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 8080
ENTRYPOINT init