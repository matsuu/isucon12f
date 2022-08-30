#!/bin/sh

set -x

################################################################################
echo "# Analyze"
################################################################################

. /tmp/prepared_env

#mkdir -p "${data_dir}"
#sudo journalctl --since="${prepared_time}" | gzip -9c > "${data_dir}/journal.log.gz"
#sudo cat "${nginx_access_log}" | gzip -9c > "${data_dir}/nginx_access.log.gz"
#sudo cat "${nginx_error_log}" | gzip -9c > "${data_dir}/nginx_error.log.gz"
#sudo cat "${mysql_error_log}" | gzip -9c > "${data_dir}/mysql_error.log.gz"

sudo cat "${nginx_access_log}" | kataribe -f "${HOME}/kataribe.toml" > "${result_dir}/kataribe.txt"

#sudo mysqltuner.pl > "${result_dir}/mysqltuner_241.txt"
#sudo cat "${mysql_slow_log}" | go-mysql-query-digest --limit 100% > "${result_dir}/pt-query-digest_241.txt"

for h in `seq 242 245` ; do
  ip="133.152.6.$h"
  ssh $ip sudo mysqltuner.pl > "${result_dir}/mysqltuner_$h.txt"
  ssh $ip sudo cat "${mysql_slow_log}" | go-mysql-query-digest --limit 100% > "${result_dir}/pt-query-digest_$h.txt"
done

#sudo git add /
#sudo git commit -av
#sudo git push origin 延長戦
