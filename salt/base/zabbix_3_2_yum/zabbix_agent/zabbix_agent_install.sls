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

zabbix_agentd_conf:
  file.managed:
    - name: {{pillar['zabbix_conf_dir']}}/zabbix_agentd.conf
    - source: salt://zabbix_3_2_yum/zabbix_agent/files/zabbix_agentd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

service_manager:
  service.running:
    - name: zabbix-agent
    - enable: True
    - watch:
      - file: zabbix_agentd_conf
