php_repo:
  cmd.run:
    - names:
      - rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
    - unless: ls /etc/yum.repos.d/|grep webtatic|grep -v grep

php_installed:
  pkg.installed:
    {% if pillar['php_version'] != 53 and pillar['php_version'] != 71 %}
    - names:
      - php{{pillar['php_version']}}w
      - php{{pillar['php_version']}}w-common
      - php{{pillar['php_version']}}w-devel
      - php{{pillar['php_version']}}w-gd
      - php{{pillar['php_version']}}w-mysql
      - php{{pillar['php_version']}}w-pdo
      - php{{pillar['php_version']}}w-cli
      - php{{pillar['php_version']}}w-ldap
      - php{{pillar['php_version']}}w-fpm
      - php{{pillar['php_version']}}w-opcache
      - php{{pillar['php_version']}}w-bcmath
      - php{{pillar['php_version']}}w-mbstring 
      - php{{pillar['php_version']}}w-xml 
    - require:
      - cmd: php_repo

    {% elif pillar['php_version'] == 71 %}
    - names:
      - mod_php{{pillar['php_version']}}w
      - php{{pillar['php_version']}}w-common
      - php{{pillar['php_version']}}w-devel
      - php{{pillar['php_version']}}w-gd
      - php{{pillar['php_version']}}w-mysql
      - php{{pillar['php_version']}}w-pdo
      - php{{pillar['php_version']}}w-cli
      - php{{pillar['php_version']}}w-ldap
      - php{{pillar['php_version']}}w-fpm
      - php{{pillar['php_version']}}w-opcache
      - php{{pillar['php_version']}}w-bcmath
      - php{{pillar['php_version']}}w-mbstring 
      - php{{pillar['php_version']}}w-xml 
    - require:
      - cmd: php_repo

    {% elif pillar['php_version'] == 53 %}
    - names:
      - php
      - php-xcache
      - php-fpm
      - php-common
      - php-mysql
      - php-pdo
      - php-bcmath
      - php-mbstring 
      - php-xml 
    {% endif %}


php_ini:
  file.managed:
    - name: {{pillar['php_conf_dir']}}/php.ini
    - source: salt://lnmp_yum/php/files/php.ini_{{pillar['php_version']}}
    - user: root
    - group: root
    - mode: 644
    - require:
      {% if pillar['php_version'] != 53 %}
      - pkg: php{{pillar['php_version']}}w-fpm
      {% elif pillar['php_version'] == 53 %}
      - pkg: php-fpm
      {% endif %}

php_www_conf:
  file.managed:
    - name: {{pillar['php_conf_dir']}}/php-fpm.d/www.conf
    - source: salt://lnmp_yum/php/files/www.conf_{{pillar['php_version']}}
    - user: root
    - group: root
    - mode: 644
    - require:
      {% if pillar['php_version'] != 53 %}
      - pkg: php{{pillar['php_version']}}w-fpm
      {% elif pillar['php_version'] == 53 %}
      - pkg: php-fpm
      {% endif %}

php_service:
  service.running:
    - name: php-fpm
    - enable: True
    - reload: True
    - watch:
      - file: php_ini
    - require:
      {% if pillar['php_version'] != 53 %}
      - pkg: php{{pillar['php_version']}}w-fpm
      {% elif pillar['php_version'] == 53 %}
      - pkg: php-fpm
      {% endif %}
    

php_info:
  file.managed:
    - name: {{pillar['nginx_root_dir']}}/phpinfo.php
    - source: salt://lnmp_yum/php/files/phpinfo.php
    - user: root
    - group: root
    - mode: 644
    - onlyif: test -d {{pillar['nginx_root_dir']}}
    - require:
      {% if pillar['php_version'] != 53 %}
      - pkg: php{{pillar['php_version']}}w-fpm
      {% elif pillar['php_version'] == 53 %}
      - pkg: php-fpm
      {% endif %}
