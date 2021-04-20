mdb_cluster:
  name: clustest
  host: mygalera01
  ip_addr: 192.168.56.111
  nodes:
    mygalera02: 192.168.56.112
    mygalera03: 192.168.56.113
    mygalera04: 192.168.56.114

mdb_ports:
  3306:
    name: mysql
    protocol: tcp
  4567:
    name: tram
    protocol: tcp
  4444:
    name: krb524
    protocol: tcp

mdb_cfg_files:
  client:
    path: /etc/my.cnf.d/mysql-clients.cnf
    source: salt://galera/config/mysql-clients.cnf
  server:
    path: /etc/my.cnf.d/server.cnf
    source: salt://galera/config/server.cnf
  mariadb:
    path: /etc/my.cnf.d/mariadb.cnf
    source: salt://galera/config/mariadb.cnf

{% if grains['osfinger'] == 'CentOS-5' %}
  {% set os = 'centos5' %}
{% elif grains['osfinger'] == 'CentOS-6' %}
  {% set os = 'centos6' %}
{% elif grains['osfinger'] == 'RedHat-5' %}
  {% set os = 'redhat5' %}
{% elif grains['osfinger'] == 'RedHat-6' %}
  {% set os = 'redhat6' %}
{% elif grains['osfinger'] == 'Fedora-17' %}
  {% set os = 'fedora17' %}
{% elif grains['osfinger'] == 'Fedora-18' %}
  {% set os = 'fedora18' %}
{% elif grains['osfinger'] == 'Fedora-19' %}
  {% set os = 'fedora19' %}
{% else %}
  {% set os = 'os_undefined' %}
{% endif %}
{% if grains['cpuarch'] == 'x86_64' %}
  {% set arch = 'amd64' %}
{% else %}
  {% set arch = 'x86' %}
{% endif %}

mdb_config:
{% if arch == 'amd64' %}
  provider: /usr/lib64/galera/libgalera_smm.so
{% else %}
  provider: /usr/lib/galera/libgalera_smm.so
{% endif %}

mdb_repo:
  baseurl: http://yum.mariadb.org/5.5/{{ os }}-{{ arch }}
