include:
  - php.php_depend

#ADD_GROUP:
#  group.present:
#    - gid: 80
#    - system: True
#      - www


www:
  user.present:
    - fullname: www
    - shell: /sbin/nologin
    - gid_from_name: True
    - uid: 80
    - gid: 80
   
COPY_PHP-5.6_PKG:
  file.managed:
    - name: /usr/local/src/php-5.6.23.tar.bz
    - source: salt://php/files/php-5.6.23.tar.bz2
    - user: root
    - group: root
    - mode: 644

COMPILE_PHP-5.6:
  cmd.run:
    - name: cd /usr/local/src && tar xf php-5.6.23.tar.bz && cd php-5.6.23 && ./configure --prefix=/usr/local/php-fastcgi --with-mysql --with-jpeg-dir  --with-png-dir  --with-zlib  --enable-xml --with-libxml-dir  --with-curl --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --enable-mbregex --with-openssl --enable-mbstring --with-gd --enable-gd-native-ttf --enable-sockets --with-xmlrpc --enable-zip --enable-soap --disable-debug -enable-opcache --enable-zip --with-config-file-path=/usr/local/php-fastcgi/etc  --enable-fpm --with-fpm-user=www --with-fpm-group=www && make && make install
    - unless: test -d /usr/local/php-fastcgi

COPY_PHP-5.6_CONF_FILE:
  file.managed:
    - name: /usr/local/php-fastcgi/etc/php-fpm.conf
    - source: salt://php/files/php-fpm.conf

COPY_PHP-5.6_START_SCRIPT:
  file.managed:
    - name: /etc/init.d/php-fpm
    - source: salt://php/files/init.d.php-fpm
    - mode: 755
    - unless: test -f /etc/init.d/php-fpm



START_PHP-5.6_SERVICE:
  service.running:
    - name: php-fpm
    - enable: True
    - restart: True
    - watch:
      - file: /usr/local/php-fastcgi/etc/php-fpm.conf
