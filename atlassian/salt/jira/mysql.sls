stop-jira:
  service.dead:
    - name: jira

mysql-connector-java-5.1.29-bin.jar:
  file.managed:
    - name: /opt/atlassian/jira/lib/mysql-connector-java-5.1.29-bin.jar
    - source: salt://jira/config/mysql-connector-java-5.1.29-bin.jar
    - require:
      - service: stop-jira

jiradb.sql:
  file.managed:
    - name: /tmp/jiradb.sql
    - source: salt://jira/config/jiradb.sql
    - user: root
    - group: root
    - mode: 644
    - template: jinja

create-user:
  cmd.run:
    - name: mysql -u root < /tmp/jiradb.sql
    - require:
      - file: jiradb.sql

/var/atlassian/application-data/jira/dbconfig.xml:
  file.managed:
    - source: salt://jira/config/dbconfig.xml.mysql
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - cmd: create-user

start-jira:
  service.running:
    - name: jira
    - require:
      - file: /var/atlassian/application-data/jira/dbconfig.xml