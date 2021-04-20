{% set dbuser = salt['pillar.get']('jira:dbuser', 'jiradbuser') %}
{% set dbpass = salt['pillar.get']('jira:dbpass', 'jira') %}
{% set dbhost = salt['pillar.get']('jira:dbhost', 'localhost') %}
{% set dbname = salt['pillar.get']('jira:dbname', 'jiradb') %}
CREATE USER '{{ dbuser }}'@'{{ dbhost }}' IDENTIFIED BY '{{ dbpass }}';
CREATE DATABASE {{ dbname }} CHARACTER SET utf8 COLLATE utf8_bin;
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,INDEX ON {{ dbname }}.* TO '{{ dbuser }}'@'{{ dbhost }}' IDENTIFIED BY '{{ dbpass }}';
FLUSH PRIVILEGES;
