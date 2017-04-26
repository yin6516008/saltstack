base:
  'minion.saltstack.com':
    - init.zabbix_agent
    - php.php_fastcgi
    - mysql.mysql_install
    - bind.bind_install
    - nginx.nginx_install
