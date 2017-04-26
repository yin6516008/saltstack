zabbix_agent:
  pkg.installed:
    - name: zabbix22-agent

  file.managed:
    - name: /etc/zabbix_agentd.conf
    - source: salt://init/files/zabbix_agentd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      Zabbix_Server: {{ pillar['zabbix-agent']['Zabbix_Server'] }}

  service.running:
    - name: zabbix-agent
    - enable: True
    - restart: True
    - watch: 
      - file: zabbix_agent
    
