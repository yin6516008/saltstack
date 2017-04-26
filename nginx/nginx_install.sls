NGINX_INSTALL:
  pkg.installed:
    - name: nginx

#nginx:
#  user.present:
#    - fullname: nginx
#    - shell: /sbin/nologin
#    - uid: 80
#    - gid: 80

COPY_NGINX_CONF_FILE:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - user: root
    - group: root
    - mode: 644

START_NGINX_SERVICE:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: /etc/nginx/nginx.conf
