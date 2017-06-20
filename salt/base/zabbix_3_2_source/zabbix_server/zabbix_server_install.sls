city_fan_repo:
  file.managed:
    - name: /etc/yum.repos.d/city-fan.org.repo
    - source: salt://zabbix_3_2_source/zabbix_server/files/city-fan.org.repo
    - user: root
    - group: root
    - mode: 644

pkg_install:
  pkg.installed:
    - names:
      - MySQL-python
      - python-devel
      - libcurl
      - libcurl-devel
      - net-snmp-devel

zabbix_install:
  file.managed:
    - name: /usr/local/src/zabbix-3.2.6.tar.gz
    - source: salt://zabbix_3_2_source/zabbix_server/files/zabbix-3.2.6.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /usr/local/src && tar -xf zabbix-3.2.6.tar.gz && cd zabbix-3.2.6 && ./configure --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2 && make && make install
    - onlyif: test -f /usr/local/src/zabbix-3.2.6.tar.gz
    - unless: test -d /usr/local/zabbix
