repo_init:
  file.managed:
    - name: /etc/yum.repos.d/mongodb-org-{{pillar['mongodb_version']}}.repo
    - source: salt://mongodb_yum/files/mongodb-org-{{pillar['mongodb_version']}}.repo
    - user: root
    - group: root
    - mode: 644

mongod_installed:
  pkg.installed:
    - names: 
      - mongodb-org
    - onlyif: 
      - names:
        - test -f /etc/yum.repo/mongodb-org-{{pillar['mongodb_version']}}.repo

server_start:
  service.running:
    - name: mongod
    - enable: True
    - require:
      - pkg: mongod_installed
