mariadb-repo:
  pkgrepo.managed:
    - comments:
      - '# MariaDB 5.5 CentOS repository list - managed by salt {{ grains['saltversion'] }}'
      - '# http://mariadb.org/mariadb/repositories/'
    - name: MariaDB
    - humanname: MariaDB
    - baseurl: {{ pillar['mdb_repo']['baseurl'] }}
    - gpgkey: https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    - gpgcheck: 1

mariadb-pkgs:
  pkg.installed:
    - names:
      - MariaDB-Galera-server
      - MariaDB-client
      - galera
    - require:
      - pkgrepo: mariadb-repo

{% for cfgfile, info in pillar['mdb_cfg_files'].iteritems() %}
{{ info['path'] }}:
  file.managed:
    - source: {{ info['source'] }}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: mariadb-pkgs
{% endfor %}

iptables:
  pkg:
    - installed

{% for port, info in pillar['mdb_ports'].iteritems() %}
port_{{ port }}:
  cmd.run:
    - name: iptables -I INPUT -p {{ info['protocol'] }} -m state --state NEW --dport {{ port }} -j ACCEPT
    - unless: "iptables -L | grep {{ info['name'] }} | grep ACCEPT"
    - require:
      - pkg: iptables
{% endfor %}

policycoreutils-python:
  pkg:
    - installed

permissive:
  selinux.mode:
    - require:
      - pkg: policycoreutils-python

rsync:
  pkg:
    - installed

mysql:
  service.running:
    - reload: True
    - watch:
      {% for cfgfile, info in pillar['mdb_cfg_files'].iteritems() %}
      - file: {{ info['path'] }}
      {% endfor %}
    - require:
      {% for port in pillar['mdb_ports'] %}
      - cmd: port_{{ port }}
      {% endfor %}
      - pkg: rsync
      - pkg: mariadb-pkgs
