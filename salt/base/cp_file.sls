/root/.bash_profile:
  file.managed:
    - source:
      - salt://file/.bash_profile

/root/.bashrc:
  file.managed:
    - source:
      - salt://file/.bashrc

/etc/profile:
  file.managed:
    - source:
      - salt://file/profile
