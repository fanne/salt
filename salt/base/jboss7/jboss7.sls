install-jboss:
  file.managed:
    - source: salt://jboss7/file/jboss-as-7.1.0.Final.zip
    - name: {{ pillar['jboss-dir']['Jboss_Dir'] }}/jboss-as-7.1.0.Final.zip
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd {{ pillar['jboss-dir']['Jboss_Dir'] }} && unzip  -q jboss-as-7.1.0.Final.zip && rm -rf jboss-as-7.1.0.Final.zip
    - unless: test -d {{ pillar['jboss-dir']['Jboss_Dir'] }}/jboss-as-7.1.0.Final


/etc/jboss-as:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - force: True
    - recurse:
      - user
      - group
      - mode
    - require:
      - file: install-jboss

/etc/jboss-as/jboss-as.conf:
  file.managed:
    - source: salt://jboss7/file/jboss-as.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: install-jboss
    - template: jinja

/etc/init.d/jboss-as-standalone:
  file.managed:
    - source: salt://jboss7/file/jboss-as-standalone
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: install-jboss
    - template: jinja

{{ pillar['jboss-dir']['Jboss_Dir'] }}/jboss-as-7.1.0.Final/bin/standalone.conf:
  file.managed:
    - source: salt://jboss7/file/standalone.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: install-jboss
    - template: jinja

{{ pillar['jboss-dir']['Jboss_Dir'] }}/jboss-as-7.1.0.Final/bin/standalone.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: install-jboss
    - template: jinja

jboss-as-standalone:
  cmd.run:
    - name: chkconfig --add jboss-as-standalone
    - unless: chkconfig --list|grep jboss-as-standalone
    - require:
      - file: install-jboss
  service.running:
    - enable: True

