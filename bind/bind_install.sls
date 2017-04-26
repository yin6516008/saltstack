include:
  - bind.bind_depend  

named:
  user.present:
    - fullname: named
    - gid_from_name: True
    - uid: 53
    - gid: 53
    - shell: /sbin/nologin


COPY_BIND-9.11_PKG:
    file.managed:
      - name: /usr/local/src/bind-9.11.0-P1.tar.gz
      - source: salt://bind/files/bind-9.11.0-P1.tar.gz
      - user: root
      - group: root
      - mode: 755
   

COMPILE_BIND-9.11:
  cmd.run:
    - name: cd /usr/local/src && tar xf bind-9.11.0-P1.tar.gz && cd bind-9.11.0-P1 && ./configure   --prefix=/usr/local/bind9  --with-dlz-mysql=/usr/local/mysql  --enable-threads=no --disable-openssl-version-check && make && make install
    - unless: test -d /usr/local/bind9

COPY_BIND-9.11_CONF_FILE:
  file.managed: 
    - name: /usr/local/bind9/etc/named.conf
    - source: salt://bind/files/named.conf
    - template: jinja
    - defaults:
      FORWARD_IP: 202.103.24.68
      DB_IP: 127.0.0.1
      DB_DATABASE: dns
      DB_USER: bind
      DB_PASSWD: bind
      DB_TABLE: dns_table

GENERATE_KEY:
  cmd.run:
    - name: cd /usr/local/bind9/sbin && ./rndc-confgen -a && ./rndc-confgen >> /usr/local/bind9/etc/named.conf

COPY_BIND-9.11_START_SCRIPT:
  file.managed:
    - name: /etc/init.d/named
    - source: salt://bind/files/named
    - user: root
    - group: root
    - mode: 755

START_BIND_SERVICE:
  service.running:
    - name: named
    - enable: True
    - restart: True
    - watch:
      - file: /usr/local/bind9/etc/named.conf
  
