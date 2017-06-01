repo_init:
  file.managed:
    - name: /etc/yum.repos.d/zabbix.repo
    - source: salt://zabbix_3_2_yum/zabbix_server/files/zabbix.repo
    - user: root
    - group: root
    - mode: 644

pkg_install:
  pkg.installed:
    - names:
      - MySQL-python
      - python-devel
      
zabbix_install:
  pkg.installed:
    - names:
      - zabbix-server-mysql
      - zabbix-web-mysql
      - zabbix-java-gateway
    - onlyif:
      - rpm -qa|grep mysql
      - java -version

db_creat:
  mysql_database.present:
    - name: {{pillar['DB_name']}}
    - connection_host: {{pillar['root_host']}}
    - connection_user: {{pillar['root_user']}}
    - connection_pass: {{pillar['root_passwd']}}
  
user_creat:
  mysql_user.present:
    - name: {{pillar['DB_user']}}
    - host: {{pillar['DB_host']}}
    - password: {{pillar['DB_passwd']}}
    - use:
      - mysql_database: db_creat

user_grant:
  mysql_grants.present:
    - grant: all privileges
    - database: {{pillar['DB_name']}}.*
    - user: {{pillar['DB_user']}}
    - host: {{pillar['DB_host']}}
    - use:
      - mysql_database: db_creat
      
sql_init:    
  cmd.run:
    - name: /bin/zcat {{pillar['zabbix_sql']}}| /usr/bin/mysql -u{{pillar['root_user']}} -p{{pillar['root_passwd']}} {{pillar['DB_name']}}   
    - onlyif: 
      - rpm -q zabbix-server-mysql
      - test -f {{pillar['zabbix_sql']}}


zabbix_server_conf:
  file.managed:
    - name: {{pillar['zabbix_conf_dir']}}/zabbix_server.conf
    - source: salt://zabbix_3_2_yum/zabbix_server/files/zabbix_server.conf
    - user: root
    - group: root
    - mode: 644

zabbix_java_gateway_conf:
  file.managed:
    - name: {{pillar['zabbix_conf_dir']}}/zabbix_java_gateway.conf
    - source: salt://zabbix_3_2_yum/zabbix_server/files/zabbix_java_gateway.conf    
    - user: root
    - group: root
    - mode: 644


service_manager:
  cmd.run:
    - name: /bin/cp -rf /usr/share/zabbix/ {{pillar['nginx_root_dir']}} 
    - onlyif:
      - test -d {{pillar['nginx_root_dir']}}
      - test -d /usr/share/zabbix
      - rpm -q zabbix-server-mysql
    
  service.running:
    - name: zabbix-server
    - enable: True
    - watch:
      - file: zabbix_server_conf
      - file: zabbix_java_gateway_conf 
    - onlyif:
      - rpm -q zabbix-server-mysql
