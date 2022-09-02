#!/bin/sh
set -ex
################################################################################
echo "# Prepare"
################################################################################

cat > /tmp/prepared_env <<EOF
prepared_time="`date +'%Y-%m-%d %H:%M:%S'`"
nginx_access_log="/var/log/nginx/access.log"
nginx_error_log="/var/log/nginx/error.log"
mysql_slow_log="/var/log/mysql/slow.log"
mysql_error_log="/var/log/mysql/error.log"
result_dir="/result"
data_dir="\${result_dir}/data"
EOF

. /tmp/prepared_env

# app
(
  cd ${HOME}/webapp/go
  go build -buildvcs=false -o isuconquest
)
sudo systemctl restart isuconquest.go

# mysql
# sudo mysql -e "TRUNCATE TABLE performance_schema.events_statements_summary_by_digest"
sudo truncate -s 0 "${mysql_slow_log}"
#sudo truncate -s 0 "${mysql_error_log}"
# sudo systemctl restart mysql

for h in `seq 242 245` ; do
  ip="133.152.6.$h"
  rsync -av --delete /home/isucon/webapp/ $ip:/home/isucon/webapp/
  ssh $ip sudo systemctl restart isuconquest.go
  ssh $ip sudo truncate -s 0 "${mysql_slow_log}"
done

# nginx
sudo truncate -s 0 "${nginx_access_log}"
#sudo truncate -s 0 "${nginx_error_log}"
# sudo systemctl reload nginx

echo "OK"
