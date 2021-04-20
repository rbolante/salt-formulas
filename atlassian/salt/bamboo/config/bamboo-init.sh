#!/bin/sh -e
# bamboo startup script
#chkconfig: 2345 80 05
#description: bamboo
 
# Name of the user to run as
USER=bamboo

BASE={{ salt['pillar.get']('bamboo:installdir', '/opt/atlassian/bamboo') + '/current' }}

export JAVA_HOME={{ pillar['bamboo']['javahome'] }}

tomcat_pid() {
   echo `ps aux | grep "Dcatalina.base=/opt/bamboo" | grep -v grep | awk '{ print $2 }'`
}
 
case "$1" in
  # Start command
  start)
    echo "Starting Bamboo..."
    /bin/su -m $USER -c "cd $BASE/logs && $BASE/bin/start-bamboo.sh &> /dev/null"
    ;;
  # Stop command
  stop)
    echo "Stopping Bamboo... "
    /bin/su -m $USER -c "$BASE/bin/stop-bamboo.sh &> /dev/null"
    echo "Bamboo stopped successfully"
    ;;
  # Restart command
  restart)
    $0 stop
    sleep 5
    $0 start
    ;;
  status)
    pid=$(tomcat_pid)
    if [ -n "$pid" ]
    then
      echo "Bamboo instance is running with pid: $pid"
    else
      echo "Bamboo instance is not running"
    fi
    ;;
  *)
    echo "Usage: /etc/init.d/bamboo {start|restart|stop}"
    exit 1
    ;;
esac
 
exit 0
