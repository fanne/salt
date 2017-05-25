jdk-install:
  file.managed:
  - source: salt://jdk_7_79/file/jdk-7u79-linux-x64.rpm
  - name: {{ pillar['jboss-dir']['Jboss_Dir'] }}/jdk-7u79-linux-x64.rpm
  - user: root
  - group: root
  - mode: 644
  
  cmd.run:
  - name: cd {{ pillar['jboss-dir']['Jboss_Dir'] }} && rpm -ivh jdk-7u79-linux-x64.rpm


jdk-evn:
  file.append:
  - name: /etc/profile
  - source: salt://jdk_7_79/file/env_jdk.txt

  cmd.run:
  - name: source /etc/profile
