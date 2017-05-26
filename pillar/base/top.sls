base:
  '*':
    - jboss7

  'lnmp_base':
    - lnmp_yum.mysql.mysql_info
    - lnmp_yum.nginx.nginx_info
    - lnmp_yum.php.php_info
