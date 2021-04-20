{% set prefix = 'http://downloads.atlassian.com/software/bamboo/downloads' %}
{% set version = salt['pillar.get']('bamboo:version', '5.4.2') %}
{% set installdir = salt['pillar.get']('bamboo:installdir', '/opt/atlassian/bamboo') %}

bamboo:
  user.present:
    - fullname: 'Alassian Bamboo'
    - shell: /bin/bash
    - home: /home/bamboo
  file.directory:
    - name: /home/bamboo/bamboo-home
    - makedirs: True

{{ installdir }}:
  file.directory:
    - user: bamboo
    - group: bamboo
    - makedirs: True

java-1.6.0-openjdk:
  pkg.installed:
    - unless: java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}' | grep 1.6

dhclient:
  cmd.run:
    - name: dhclient
    - unless: 'ps -ef | grep dhclient'

wget:
  pkg:
    - installed

/tmp/atlassian-bamboo-{{ version }}.tar.gz:
  cmd.run:
    - name: wget {{ prefix }}/atlassian-bamboo-{{ version }}.tar.gz
    - unless: test -e /tmp/atlassian-bamboo-{{ version }}.tar.gz
    - require:
      - pkg: wget
      - cmd: dhclient

# /tmp/atlassian-bamboo-{{ version }}.tar.gz:
#   file.managed:
#     - source: {{ prefix }}/atlassian-bamboo-{{ version }}.tar.gz
#     - source_hash: md5={{ prefix }}/atlassian-bamboo-{{ version }}.tar.gz.md5

extract-pkg:
  cmd.run:
    - name: tar zxvf /tmp/atlassian-bamboo-{{ version }}.tar.gz
    - unless: test -e {{ installdir }}
    - cwd: {{ installdir }}

bamboo-symlink:
  file.symlink:
    - target: atlassian-bamboo-{{ version }}
    - cwd: {{ installdir }}
    - name: {{ installdir }}/current

{{ installdir }}/current/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties:
  file.append:
    - text:
      - 'bamboo.home=/home/bamboo/bamboo-home'

/etc/init.d/bamboo:
  file.managed:
    - source: salt://bamboo/config/bamboo_init.sh
    - unless: test -e /etc/init.d/bamboo
    - mode: 0755
    - template: jinja