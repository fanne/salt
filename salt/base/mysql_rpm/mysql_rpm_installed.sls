rpm_remove:
  pkg.removed:
    - names:
      - mysql
      - mysql-devel
      - mysql-libs



rpm_cp:
  pkg.installed:
    - names:
      - MySQL-python

  file.managed:
    - name: /tmp/soft/mysql_{{pillar['mysql_version']}}_rpm.zip
    - source: salt://mysql_rpm/files/rpm/mysql_{{pillar['mysql_version']}}_rpm.zip
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - unless:
      - name: test -f /tmp/soft/mysql_{{pillar['mysql_version']}}_rpm.zip

  cmd.run:
    - names:
      - cd /tmp/soft && unzip -q mysql_{{pillar['mysql_version']}}_rpm.zip
      
rpm_installed:
  cmd.run:
    - names:
      - cd /tmp/soft/mysql_{{pillar['mysql_version']}}_rpm
      - rpm -i --replacefiles libaio*.rpm numactl*.rpm perl-DBI*.rpm
      - rpm -ivh --replacefiles mysql-community-common*.rpm 
      - rpm -ivh --replacefiles mysql-community-libs*.rpm
      - rpm -ivh --replacefiles mysql-community-client*.rpm
      - rpm -ivh --replacefiles mysql-community-server*.rpm
    - unless:
      - test -d /tmp/soft/mysql_{{pillar['mysql_version']}}_rpm

mysqld_start:
  file.managed:
    - name: /etc/init.d/mysqld
    - source: salt://mysql_rpm/files/mysqld/mysqld-{{pillar['mysql_version']}}
    - user: root
    - group: root
    - mode: 755

  cmd.run:
    - names:
        - /sbin/chkconfig --add mysqld 
        - /sbin/chkconfig --level 35 mysqld on
    - unless: /sbin/chkconfig --list mysqld

  service.running:
    - name: mysqld
    - enable: True

  mysql_user.present:
    - name: {{pillar['root_user']}}
    - host: {{pillar['root_host']}}
    - password: {{pillar['root_passwd']}}
    
