nginx_installed:
  pkg.installed:
    - names:
      - nginx

  file.managed:
    - name: {{pillar['nginx_conf_dir']}}/default.conf
    - source: salt://lnmp_yum/nginx/files/default.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: {{pillar['nginx_conf_dir']}}/default.conf
    - require:
      - pkg: nginx
