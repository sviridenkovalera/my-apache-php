!/bin/bash
set -e

source /etc/apache2/envvars
apache2 -D FOREGROUND

exec "$@"