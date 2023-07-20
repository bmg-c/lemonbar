#/bin/sh

ps -ef | grep 'lemonbar' | grep -v grep | awk '{print $2}' | xargs -r kill -9

ps -ef | grep 'bar.sh' | grep -v grep | awk '{print $2}' | xargs -r kill -9
ps -ef | grep 'secbar.sh' | grep -v grep | awk '{print $2}' | xargs -r kill -9
