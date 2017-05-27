base:
  '*':
    - jboss7

  'zabbix_server':
    - lnmp_yum.mysql.mysql_info
    - lnmp_yum.nginx.nginx_info
    - lnmp_yum.php.php_info
