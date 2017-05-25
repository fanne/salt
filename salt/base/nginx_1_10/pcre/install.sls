include:
  - nginx_1_10.initpkg.install

pcre-source-install:
  file.managed:
    - name: /usr/local/src/pcre-8.40.tar.gz
    - source: salt://nginx_1_10/pcre/file/pcre-8.40.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /usr/local/src && tar -xf pcre-8.40.tar.gz && cd pcre-8.40 && ./configure --prefix=/usr/local/pcre && make && make install
    - unless: test -d /usr/local/pcre
    - require:
      - file: pcre-source-install
