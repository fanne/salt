pkg_install:
  file.managed:
    - name: /etc/yum.repos.d/mysql-5.6.repo
    - source: salt://mysqlTest/files/mysql-5.6.repo
    - user: root
    - group: root
    - mode: 644

  pkg.installed:
    - names:
      - mysql-community-server
      - mysql-community-client

  service.running:
    - name: mysqld
    - enable: True
