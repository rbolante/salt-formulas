{% set prefix = 'http://downloads.atlassian.com/software/jira/downloads' %}
{% set version = pillar['jira']['version'] %}
{% set arch = pillar['jira']['arch'] %}

{%- if pillar['jira']['filetype'] == 'binary' %}
  {% set file_ext = 'bin' %}
{%- elif pillar['jira']['filetype'] == 'war' %}
  {% set file_ext = '-war.tar.gz' %}
{%- else %}
  {% set file_ext = 'tar.gz' %}
{%- endif %}

dhclient:
  cmd.run:
    - name: dhclient
    - unless: 'ps -ef | grep dhclient'

wget:
  pkg:
    - installed

get-jira:
  cmd.run:
    - name: wget {{ prefix }}/atlassian-jira-{{ version }}-{{ arch }}.{{ file_ext }} && chmod +x atlassian-jira-{{ version }}-{{ arch }}.{{ file_ext }}
    - unless: test -e /opt/atlassian/jira/bin
    - require:
      - pkg: wget
      - cmd: dhclient

# TODO: check why this is not working, using wget for the meantime
# atlassian-jira-{{ version }}-{{ arch }}.{{ file_ext }}:
#   file.managed:
#     - name: /tmp/atlassian-jira-{{ version }}-{{ arch }}.{{ file_ext }}
#     - source: {{ prefix }}/atlassian-jira-{{ version }}-{{ arch }}.{{ file_ext }}
#     - source_hash: md5={{ prefix }}/atlassian-jira-{{ version }}-{{ arch }}.{{ file_ext }}.md5
#     - unless: test -e /opt/atlassian/jira/bin
#     - require:
#       - cmd: dhclient

resp-file:
  file.managed:
    - name: /tmp/response.varfile
    - source: salt://jira/config/response.varfile

install-jira:
  cmd.run:
    - name: ./atlassian1-jira-{{ version }}-{{ arch }}.{{ file_ext }} -q -varfile /tmp/response.varfile
    - require:
      - file: resp-file

iptables:
  service.dead:
    - require:
      - cmd: install-jira

jira:
  service.running:
    - require:
      - service: iptables