#!/bin/sh

# vim: tabstop=4 shiftwidth=4 softtabstop=4
#
#  Copyright (c) 2011 Openstack, LLC.
#  All Rights Reserved.
#
#     Licensed under the Apache License, Version 2.0 (the "License"); you may
#     not use this file except in compliance with the License. You may obtain
#     a copy of the License at
#
#          http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#     WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#     License for the specific language governing permissions and limitations
#     under the License.
#
# nova-agent	Startup script for OpenStack nova guest agent
#
# RedHat style init header:
#
# chkconfig: 2345 15 85
# description: nova-agent is an agent meant to run on unix guest instances \
#              being managed by OpenStack nova.  Currently only works with \
#              Citrix XenServer for manipulating the guest through \
#              xenstore.
# processname: nova-agent
# pidfile: /var/run/nova-agent.pid
#
# LSB style init header:
#
### BEGIN INIT INFO
# Provides: Nova-Agent
# Required-Start: $remote_fs $syslog xe-linux-distribution
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start nova-agent at boot time
# Description: nova-agent is a guest agent for OpenStack nova.
### END INIT INFO

# Source function library.
if [ -e "/etc/rc.d/init.d/functions" ]
then
  . /etc/rc.d/init.d/functions
fi

PROG=/usr/local/bin/nova-agent
pid_file=/var/run/nova-agent.pid
LOCK=/var/lock/subsys/$PROG

do_start() {
    export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin"
    daemon $PROG -p $pid_file
    RETVAL=$?
    [ $RETVAL -eq 0 ] && touch $LOCK
    echo
    return $RETVAL
}

do_stop() {
    killproc $PROG || failure
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f $LOCK
    return $RETVAL
}

case "$1" in
  start)
    do_start
    ;;
  stop)
    do_stop
    ;;
  restart)
    do_stop
    do_start
    ;;
  *)
    echo "Usage: $SCRIPTNAME {start|stop|restart}" >&2
    exit 3
    ;;
esac
