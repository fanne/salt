repo_init:
  file.managed:
    - name: /etc/yum.repos.d/mysql-{{pillar['mysql_version']}}.repo
    - source: salt://lnmp_yum/mysql/files/mysql-{{pillar['mysql_version']}}.repo
    - user: root
    - group: root
    - mode: 644

rpm_remove:
  pkg.removed:
    - names:
      - mysql
      - mysql-devel
      - mysql-libs
mysql_install:
  pkg.installed:
    - names:
      - MySQL-python
      - mysql-community-server
      - mysql-community-devel
      - mysql-community-common
      - mysql-community-libs
      - mysql-community-client
    - onlyif:
      - names:
        - test -f /etc/yum.repos.d/mysql-{{pillar['mysql_version']}}.repo



  file.managed:
    - name: {{pillar['mysql_conf_dir']}}/my.cnf
    - source: salt://lnmp_yum/mysql/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: mysqld


    - name: /etc/init.d/mysqld
    - source: salt://lnmp_yum/mysql/files/mysqld-{{pillar['mysql_version']}}
    - user: root
    - group: root
    - mode: 755
    - watch_in:
      - service: mysqld

  cmd.run:
    - names:
        - /sbin/chkconfig --add mysqld 
        - /sbin/chkconfig --level 35 mysqld on
    - unless: /sbin/chkconfig --list mysqld

  service.running:
    - name: mysqld
    - enable: True
   # - reload: True
   # - require:
    #  - pkg: mysql-community-server
      
  mysql_user.present:
    - name: {{pillar['root_user']}}
    - host: {{pillar['root_host']}}
    - password: {{pillar['root_passwd']}}     

