pkg_install:
  pkg.installed:
    - names:
      - MySQL-python
      - python-devel

db_creat:
  mysql_database.present:
    - name: zabbix_test
    - connection_host: localhost
    - connection_user: root
    - connection_pass: qwe123
  
user_creat:
  mysql_user.present:
    - name: zabbix_test
    - host: localhost
    - password: zabbix_test
    - use:
      - mysql_database: db_creat

user_grant:
  mysql_grants.present:
    - grant: all privileges
    - database: zabbix_test.*
    - user: zabbix_test
    - host: 'localhost'
    - use:
      - mysql_database: db_creat
