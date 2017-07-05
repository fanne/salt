repo_init:
  file.managed:
    - name: /etc/yum.repos.d/saltstack.repo
    - source: salt://salt_minion_yum/files/saltstack.repo
    - user: root
    - group: root
    - mode: 644

salt_minion_install:
  pkg.installed:
    - names:
      - salt-minion

salt_minion_conf:
    file.managed:
    - name: /etc/salt/minion
    - source: salt://salt_minion_yum/files/minion
    - user: root
    - group: root
    - mode: 644
    - template: jinja

service_manager:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - file: salt_minion_conf
