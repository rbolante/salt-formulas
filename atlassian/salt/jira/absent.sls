stop-jira:
  service.dead:
    - name: jira

uninstall:
  cmd.run:
    - name: uninstall -q
    - cwd: /opt/atlassian/jira
    - require:
      - service: stop-jira
