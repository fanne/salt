pkg_install:
  pkg.installed:
    - names:
      - MySQL-python
      - mysql-server

  service.running:
    - name: mysqld
    - enable: True

  mysql_user.present:
    - name: {{pillar['root_user']}}
    - host: {{pillar['root_host']}}
    - password: {{pillar['root_passwd']}} 
