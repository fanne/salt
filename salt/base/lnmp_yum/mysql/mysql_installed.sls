repo_init:
  file.managed:
    - name: /etc/yum.repos.d/mysql-{{pillar['mysql_version']}}.repo
    - source: salt://lnmp_yum/mysql/files/mysql-{{pillar['mysql_version']}}.repo
    - user: root
    - group: root
    - mode: 644

mysql_install:
  pkg.installed:
    - names:
      - mysql
      - mysql-server
      - mysql-devel
    - require:
      - file: repo_init    

  file.managed:
    - name: {{pillar['mysql_conf_dir']}}/my.cnf
    - source: salt://lnmp_yum/mysql/files/my.cnf
    - user: root
    - group: root
    - mode: 644
   # - watch_in:
   #   - service: mysqld


  #service.running:
  #  - name: mysqld
  #  - enable: True
  #  - reload: True

