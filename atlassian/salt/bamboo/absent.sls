{% set installdir = salt['pillar.get']('bamboo:installdir', '/opt/atlassian/bamboo') %}

bamboo-svc:
  service.dead:
    - name: bamboo

/etc/init.d/bamboo:
  file.absent:
    - require:
      - service: bamboo

{{ installdir }}:
  file.absent:
    - require:
      - file: /etc/init.d/bamboo

bamboo-user:
  user.absent:
    - name: bamboo
    - require:
      - file: {{ installdir }}