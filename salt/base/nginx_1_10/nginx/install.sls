include:
  - nginx_1_10.initpkg.install
  - nginx_1_10.pcre.install

nginx-source-install:
  file.managed:
    - name: /usr/local/src/nginx-1.10.0.tar.gz
    - source: salt://nginx_1_10/nginx/file/nginx-1.10.0.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /usr/local/src && tar -xf nginx-1.10.0.tar.gz && cd nginx-1.10.0 && ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_stub_status_module --with-file-aio --with-http_dav_module --with-pcre=/usr/local/src/pcre-8.40 && make && make install
    - unless: test -d /user/local/nginx
    - require:
      - file: nginx-source-install
      - pkg: init-pkg-install
      - file: pcre-source-install

nginx-init:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://nginx_1_10/nginx/file/nginx
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: /sbin/chkconfig --add nginx
    - require:
      - cmd: nginx-source-install
      - file: nginx-init

nginx-service:
  service.running:
    - name: nginx
    - enable: nginx
    - reload: true
    - require:
      - cmd: nginx-init

