mysql:
  user.present:
    - fullname: mysql
    - shell: /sbin/nologin
    - gid_from_name: True
    - uid: 306
    - gid: 306

ADD_MYSQL-5.5_DATEDIR:
  file.directory:
    - names:
      - /mydata/data
    - user: mysql
    - group: mysql
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True
    
COPY_MYSQL-5.5_PKG:
  file.managed:
    - name: /usr/local/src/mysql-5.5.49-linux2.6-x86_64.tar.gz
    - source: salt://mysql/files/mysql-5.5.49-linux2.6-x86_64.tar.gz

COMPILE_MYSQL-5.5:
  cmd.run:
    - name: cd /usr/local/src && tar xf mysql-5.5.49-linux2.6-x86_64.tar.gz && ln -s /usr/local/src/mysql-5.5.49-linux2.6-x86_64  /usr/local/mysql && cd /usr/local/mysql && chown -R mysql.mysql . && ./scripts/mysql_install_db --user=mysql  --datadir=/mydata/data
    - unless: test -d /usr/local/mysql

/etc/my.cnf:
  file.managed:
    - source: salt://mysql/files/mysql-5.5.49.conf
    
/etc/init.d/mysqld:
  file.managed:
    - source: salt://mysql/files/mysql-5.5.49.server
    - user: root
    - group: root
    - mode: 744

ADD_MYSQL-5.5_BIN_PATH:
  cmd.run:
    - name: echo 'export PATH=$PATH:/usr/local/mysql/bin' > /etc/profile.d/mysql.sh && chmod +x /etc/profile.d/mysql.sh && . /etc/profile.d/mysql.sh
    - unless: test -f /etc/profile.d/mysql.sh

START_MYSQLD-5.5:
  service.running:
    - name: mysqld
    - enable: True
    - restart: True
    - watch:
      - file: /etc/my.cnf
