server_pkgs:
  pkg:
    - installed
    - pkgs:
      - python-devel
    - refresh: True

mysql_python_pkgs:
  pkg.installed:
    - pkgs:
      - libmysqlclient-dev
      - mysql-client
      - python-mysqldb
    - require:
      - pkg: server_pkgs

python-pip:
  pkg:
    - installed
    - refresh: False

