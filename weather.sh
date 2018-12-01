#!/bin/bash

set +x

IP=`dig @resolver1.opendns.com ANY myip.opendns.com +short`
echo "Detcted ip $IP"
echo "Getting location ..."
curl -s "http://api.ipstack.com/$IP?access_key=97964aaac298a854b843a30c4b6f2678" > /tmp/location

LON=`cat /tmp/location | jq -r '.longitude'`
LAT=`cat /tmp/location | jq -r '.latitude'`

echo "dectected latitude: $LAT longitude: $LON"

TEMP=`curl -s 'http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=3c5426331cd1654a68922657a19c24c8'| jq -r '.main.temp'`

PRE_TEMP=`cat ~/.weather`

if ((  $(echo "$PRE_TEMP > $TEMP + 2" |bc -l) )); then
	notify-send "$HOSTNAME temprature decreased get your hoodie on!"
elif ((  $(echo "$TEMP > $PRE_TEMP + 2" |bc -l) )); then
	notify-send  "$HOSTNAME temprature increase get some chilled soda"
fi
