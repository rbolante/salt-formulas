{% set arch = 'x32' %}
{% if grains['osarch'] == 'x86_64' %}
  {% set arch = 'x64' %}
{% endif %}

jira:
  version: 6.2
  filetype: binary
  arch: {{ arch }}
  language: en
  installdir: /opt/atlassian/jira
  dbuser: jiradbuser
  dbpass: jira
  dbname: jiradb
  dbhost: localhost

bamboo:
  version: 5.4.2
  installdir: /opt/atlassian/bamboo
  javahome: /usr/lib/jvm/jre-1.6.0-openjdk.x86_64
