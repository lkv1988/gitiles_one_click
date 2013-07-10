#!/bin/sh
#
# Copyright 2012 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

ROOT="$(dirname "$0")/.."
VERSION="$(grep '^  <version>' "$ROOT/pom.xml" | sed 's/\s*<[^>]*>\s*//g')"
PROPERTIES=
#if [ "x$1" != "x" ]; then
#  PROPERTIES="-Dcom.google.gitiles.configPath=$1"
#fi

ACTION=$1
PIDFILE="gitiles.pid"


if [ -z $ACTION ]
then
    echo "rundev.sh [start|stop]"
    exit 1
fi

case $ACTION in
    start|--start)
        if [ ! -f $PIDFILE ]
        then
            touch $PIDFILE
        fi
        java $PROPERTIES -jar "$ROOT/gitiles-dev/target/gitiles-dev-$VERSION.jar" >/dev/null 2>&1 &
        PID=$!
        echo $PID > $PIDFILE
        echo "Start OK, pid is $PID"
        ;;
    stop|--stop)
        if [ -f $PIDFILE ]
        then
            PID=`cat $PIDFILE`
            kill $PID
            rm -f $PIDFILE
            echo "Stop OK, process($PID) has been killed."
        else
            echo "Process has not started yet."
        fi
        ;;
    *)
        echo "rundev.sh [start|stop]"
        exit 1
        ;;
esac
