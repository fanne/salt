repo_init:
  file.managed:
    - name: /etc/yum.repos.d/zabbix.repo
    - source: salt://zabbix_3_2_yum/zabbix_agent/files/zabbix.repo
    - user: root
    - group: root
    - mode: 644

zabbix_install:
  pkg.installed:
    - names:
      - zabbix-agent

service_manager:
  service.running:
    - name: zabbix-agent
