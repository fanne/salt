php_installed:
  pkg.installed:
    - names:
      - php-xcache
      - php-fpm
      - php-common
      - php-mysql
      - php-pdo


  file.managed:
    - name: {{pillar['php_conf_dir']}}/php.ini
    - source: salt://lnmp_yum/php/files/php.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm


  service.running:
    - name: php-fpm
    - enable: True
    - require:
      - pkg: php-fpm

php_info:
  file.managed:
    - name: {{pillar['root_dir']}}/phpinfo.php
    - source: salt://lnmp_yum/php/files/phpinfo.php
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm
