#!/bin/bash

while :
do
	if compgen -G "/opt/employee/webhook-events/*.webhook" > /dev/null; then
    		echo "new webhhok found"
    		rm -rf /opt/employee/webhook-events/*.webhook
    		bash /opt/employee/scripts/deploy-api.sh
	fi
	echo "Press [CTRL+C] to stop.."
	sleep 10
done
