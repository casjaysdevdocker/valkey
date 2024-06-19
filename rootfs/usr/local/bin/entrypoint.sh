#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202406191015-git
# @@Author           :  Jason Hempstead
# @@Contact          :  jason@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  docker-entrypoint --help
# @@Copyright        :  Copyright: (c) 2024 Jason Hempstead, Casjays Developments
# @@Created          :  Wednesday, Jun 19, 2024 10:15 EDT
# @@File             :  docker-entrypoint
# @@Description      :  
# @@Changelog        :  New script
# @@TODO             :  Better documentation
# @@Other            :  
# @@Resource         :  
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  other/docker-entrypoint
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck disable=SC2016
# shellcheck disable=SC2031
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# shellcheck disable=SC2317
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
CONTAINER_NAME="valkey"
SCRIPT_NAME="$(basename "$0" 2>/dev/null)"
[ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -o pipefail -x$DEBUGGER_OPTIONS || set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# remove whitespaces from beginning argument
while :; do [ "$1" = " " ] && shift 1 || break; done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$1" = "$0" ] && shift 1
[ "$1" = "$SCRIPT_NAME" ] && shift 1
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import the functions file
if [ -f "/usr/local/etc/docker/functions/entrypoint.sh" ]; then
  . "/usr/local/etc/docker/functions/entrypoint.sh"
else
  echo "Can not load functions from /usr/local/etc/docker/functions/entrypoint.sh"
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create the default env files
__create_env_file "/config/env/default.sh" "/root/env.sh" &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import variables from files
for set_env in "/root/env.sh" "/usr/local/etc/docker/env"/*.sh "/config/env"/*.sh; do
  [ -f "$set_env" ] && . "$set_env"
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Builtin functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Custom functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define script variables
RUNAS_USER=""    # Default is root
SERVICE_UID=""   # set the user id
SERVICE_GID=""   # set the group id
SERVICE_USER=""  # execute command as another user
SERVICE_GROUP="" # Set the service group
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Primary server port- will be added to server ports
WEB_SERVER_PORT="" # port : 80,443
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Secondary ports
SERVER_PORTS="" # specifiy other ports
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Server directories
WWW_ROOT_DIR="" # set default web dir
DATABASE_DIR="" # set database dir
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Healthcheck variables
HEALTH_ENABLED="yes" # enable healthcheck [yes/no]
SERVICES_LIST="tini" # comma seperated list of processes for the healthcheck
HEALTH_ENDPOINTS=""  # url endpoints: [http://localhost/health,http://localhost/test]
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Overwrite variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__run_message() {

  return
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
################## END OF CONFIGURATION #####################
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Startup variables
export INIT_DATE="${INIT_DATE:-$(date)}"
export START_SERVICES="${START_SERVICES:-yes}"
export ENTRYPOINT_MESSAGE="${ENTRYPOINT_MESSAGE:-yes}"
export ENTRYPOINT_FIRST_RUN="${ENTRYPOINT_FIRST_RUN:-yes}"
export DATA_DIR_INITIALIZED="${DATA_DIR_INITIALIZED:-false}"
export CONFIG_DIR_INITIALIZED="${CONFIG_DIR_INITIALIZED:-false}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# System
export LANG="${LANG:-C.UTF-8}"
export LC_ALL="${LANG:-C.UTF-8}"
export TZ="${TZ:-${TIMEZONE:-America/New_York}}"
export HOSTNAME="${FULL_DOMAIN_NAME:-${SERVER_HOSTNAME:-$HOSTNAME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Default directories
export SSL_DIR="${SSL_DIR:-/config/ssl}"
export SSL_CA="${SSL_CERT:-/config/ssl/ca.crt}"
export SSL_KEY="${SSL_KEY:-/config/ssl/localhost.pem}"
export SSL_CERT="${SSL_CERT:-/config/ssl/localhost.crt}"
export BACKUP_DIR="${BACKUP_DIR:-/data/backups}"
export LOCAL_BIN_DIR="${LOCAL_BIN_DIR:-/usr/local/bin}"
export DEFAULT_DATA_DIR="${DEFAULT_DATA_DIR:-/usr/local/share/template-files/data}"
export DEFAULT_CONF_DIR="${DEFAULT_CONF_DIR:-/usr/local/share/template-files/config}"
export DEFAULT_TEMPLATE_DIR="${DEFAULT_TEMPLATE_DIR:-/usr/local/share/template-files/defaults}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Additional
export PHP_INI_DIR="${PHP_INI_DIR:-$(__find_php_ini)}"
export PHP_BIN_DIR="${PHP_BIN_DIR:-$(__find_php_bin)}"
export HTTPD_CONFIG_FILE="${HTTPD_CONFIG_FILE:-$(__find_httpd_conf)}"
export NGINX_CONFIG_FILE="${NGINX_CONFIG_FILE:-$(__find_nginx_conf)}"
export MYSQL_CONFIG_FILE="${MYSQL_CONFIG_FILE:-$(__find_mysql_conf)}"
export PGSQL_CONFIG_FILE="${PGSQL_CONFIG_FILE:-$(__find_pgsql_conf)}"
export MONGODB_CONFIG_FILE="${MONGODB_CONFIG_FILE:-$(__find_mongodb_conf)}"
export ENTRYPOINT_PID_FILE="${ENTRYPOINT_PID_FILE:-/run/init.d/entrypoint.pid}"
export ENTRYPOINT_INIT_FILE="${ENTRYPOINT_INIT_FILE:-/config/.entrypoint.done}"
export ENTRYPOINT_DATA_INIT_FILE="${ENTRYPOINT_DATA_INIT_FILE:-/data/.docker_has_run}"
export ENTRYPOINT_CONFIG_INIT_FILE="${ENTRYPOINT_CONFIG_INIT_FILE:-/config/.docker_has_run}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_PID_FILE" ] || [ -f "$ENTRYPOINT_INIT_FILE" ]; then
  START_SERVICES="no" ENTRYPOINT_MESSAGE="no" ENTRYPOINT_FIRST_RUN="no"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# variables based on env/files
[ "$WEB_SERVER_PORT" = "443" ] && SSL_ENABLED="true"
[ -f "/config/enable/ssl" ] && SSL_ENABLED="true"
[ -f "/config/enable/ssh" ] && SSH_ENABLED="true"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export variables

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# is already Initialized
[ -f "$ENTRYPOINT_DATA_INIT_FILE" ] && DATA_DIR_INITIALIZED="true" || DATA_DIR_INITIALIZED="false"
[ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ] && CONFIG_DIR_INITIALIZED="true" || CONFIG_DIR_INITIALIZED="false"
{ [ -f "$ENTRYPOINT_PID_FILE" ] || [ -f "$ENTRYPOINT_INIT_FILE" ]; } && ENTRYPOINT_FIRST_RUN="no" || ENTRYPOINT_FIRST_RUN="true"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# clean ENV_PORTS variables
ENV_PORTS="${ENV_PORTS//,/ }"  #
ENV_PORTS="${ENV_PORTS//\/*/}" #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# clean SERVER_PORTS variables
SERVER_PORTS="${SERVER_PORTS//,/ }"  #
SERVER_PORTS="${SERVER_PORTS//\/*/}" #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# clean WEB_SERVER_PORTS variables
WEB_SERVER_PORTS="${WEB_SERVER_PORT//\/*/}"                             #
WEB_SERVER_PORTS="${WEB_SERVER_PORTS//\/*/}"                            #
WEB_SERVER_PORTS="${WEB_SERVER_PORT//,/ } ${ENV_WEB_SERVER_PORTS//,/ }" #
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rewrite and merge variables
ENV_PORTS="$(__format_variables "$ENV_PORTS" || false)"
WEB_SERVER_PORTS="$(__format_variables "$WEB_SERVER_PORTS" || false)"
ENV_PORTS="$(__format_variables "$SERVER_PORTS" "$WEB_SERVER_PORTS" "$ENV_PORTS" "$SERVER_PORTS" || false)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
HEALTH_ENDPOINTS="${HEALTH_ENDPOINTS//,/ }"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create required directories
mkdir -p "/run"
mkdir -p "/tmp"
mkdir -p "/root"
mkdir -p "/var/run"
mkdir -p "/var/tmp"
mkdir -p "/run/cron"
mkdir -p "/data/logs"
mkdir -p "/run/init.d"
mkdir -p "/config/enable"
mkdir -p "/config/secure"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create required files
touch "/data/logs/entrypoint.log"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# fix permissions
chmod -f 777 "/run"
chmod -f 777 "/tmp"
chmod -f 700 "/root"
chmod -f 777 "/var/run"
chmod -f 777 "/var/tmp"
chmod -f 777 "/run/cron"
chmod -f 777 "/data/logs"
chmod -f 777 "/run/init.d"
chmod -f 666 "/dev/stderr"
chmod -f 666 "/dev/stdout"
chmod -f 777 "/config/enable"
chmod -f 777 "/config/secure"
chmod -f 777 "/data/logs/entrypoint.log"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cat <<EOF >/etc/profile.d/locales.shadow
export LANG="\${LANG:-C.UTF-8}"
export LC_ALL="\${LANG:-C.UTF-8}"
export TZ="\${TZ:-\${TIMEZONE:-America/New_York}}"
EOF
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create the backup dir
[ -n "$BACKUP_DIR" ] && { [ -d "$BACKUP_DIR" ] || mkdir -p "$BACKUP_DIR"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$ENTRYPOINT_FIRST_RUN" != "no" ]; then
  # Show start message
  if [ "$CONFIG_DIR_INITIALIZED" = "false" ] || [ "$DATA_DIR_INITIALIZED" = "false" ]; then
    [ "$ENTRYPOINT_MESSAGE" = "yes" ] && echo "Executing entrypoint script for valkey"
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Set reusable variables
  { { [ -w "/etc" ] && [ ! -e "/etc/hosts" ]; } || [ -w "/etc/hosts" ]; } && UPDATE_FILE_HOSTS="true"
  { { [ -w "/etc" ] && [ ! -e "/etc/timezone" ]; } || [ -w "/etc/timezone" ]; } && UPDATE_FILE_TZ="true"
  { { [ -w "/etc" ] && [ ! -e "/etc/resolv.conf" ]; } || [ -w "/etc/resolv.conf" ]; } && UPDATE_FILE_RESOLV="true"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Set timezone
  [ -n "$TZ" ] && [ "$UPDATE_FILE_TZ" = "true" ] && echo "$TZ" >"/etc/timezone"
  [ -f "/usr/share/zoneinfo/$TZ" ] && [ "$UPDATE_FILE_TZ" = "true" ] && ln -sf "/usr/share/zoneinfo/$TZ" "/etc/localtime"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # if ipv6 add it to /etc/hosts
  if [ "$UPDATE_FILE_HOSTS" = "true" ]; then
    echo "# known hostname mappings" >"/etc/hosts"
    if [ -n "$(ip a 2>/dev/null | grep 'inet6.*::' || ifconfig 2>/dev/null | grep 'inet6.*::')" ]; then
      __printf_space "40" "::1" "localhost" >>"/etc/hosts"
      __printf_space "40" "127.0.0.1" "localhost" >>"/etc/hosts"
    else
      __printf_space "40" "127.0.0.1" "localhost" >>"/etc/hosts"
    fi
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # add .home domain
  if [ "$UPDATE_FILE_HOSTS" = "true" ] && [ -n "$HOSTNAME" ]; then
    __grep_test " $HOSTNAME" "/etc/hosts" || __printf_space "40" "${CONTAINER_IP4_ADDRESS:-127.0.0.1}" "$HOSTNAME" >>"/etc/hosts"
    __grep_test " ${HOSTNAME%%.*}.home" "/etc/hosts" || __printf_space "40" "${CONTAINER_IP4_ADDRESS:-127.0.0.1}" "${HOSTNAME%%.*}.home" >>"/etc/hosts"
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # add domainname
  if [ "$UPDATE_FILE_HOSTS" = "true" ] && [ "$DOMAINNAME" != "home" ] && [ -n "$DOMAINNAME" ] && [ "$HOSTNAME.$DOMAINNAME" != "$DOMAINNAME" ]; then
    __grep_test " ${HOSTNAME%%.*}.$DOMAINNAME" "/etc/hosts" || __printf_space "40" "${CONTAINER_IP4_ADDRESS:-127.0.0.1}" "${HOSTNAME%%.*}.$DOMAINNAME" >>"/etc/hosts"
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Set containers hostname
  [ -n "$HOSTNAME" ] && [ "$UPDATE_FILE_HOSTS" = "true" ] && echo "$HOSTNAME" >"/etc/hostname"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Set containers hostname with domain
  # [ -n "$DOMAINNAME" ] && [ "$UPDATE_FILE_HOSTS" = "true" ] && echo "$HOSTNAME.$DOMAINNAME" >"/etc/hostname"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if [ -f "/etc/hostname" ]; then
    [ -n "$(type -P hostname)" ] && hostname -F "/etc/hostname" &>/dev/null || HOSTNAME="$(<"/etc/hostname")"
    export HOSTNAME
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # import hosts file into container
  [ -f "/usr/local/etc/hosts" ] && [ "$UPDATE_FILE_HOSTS" = "true" ] && cat "/usr/local/etc/hosts" | grep -vF "$HOSTNAME" >>"/etc/hosts"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # import resolv.conf file into container
  [ "$CUSTOM_DNS" != "true" ] && [ -f "/usr/local/etc/resolv.conf" ] && [ "$UPDATE_FILE_RESOLV" = "true" ] && cat "/usr/local/etc/resolv.conf" >"/etc/resolv.conf"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if [ -d "/usr/local/etc/skel" ]; then
    cp -Rf "/usr/local/etc/skel/." "$HOME/"
  fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Delete any .gitkeep files
[ -d "/data" ] && rm -Rf "/data/.gitkeep" "/data"/*/*.gitkeep
[ -d "/config" ] && rm -Rf "/config/.gitkeep" "/config"/*/*.gitkeep
[ -f "/usr/local/bin/.gitkeep" ] && rm -Rf "/usr/local/bin/.gitkeep"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup bin directory - /config/bin > /usr/local/bin
__initialize_custom_bin_dir
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy default system configs - /usr/local/share/template-files/defaults > /config/
__initialize_default_templates
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy custom config files - /usr/local/share/template-files/config > /config/
__initialize_config_dir
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy custom data files - /usr/local/share/template-files/data > /data/
__initialize_data_dir
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__initialize_ssl_certs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_PID_FILE" ] || [ -f "$ENTRYPOINT_INIT_FILE" ]; then
  START_SERVICES="no"
  ENTRYPOINT_MESSAGE="no"
  ENTRYPOINT_FIRST_RUN="no"
  touch "$ENTRYPOINT_PID_FILE"
elif [ -d "/config" ]; then
  echo "$$" >"$ENTRYPOINT_PID_FILE"
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_INIT_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if this is a new container
if [ -f "$ENTRYPOINT_DATA_INIT_FILE" ]; then
  DATA_DIR_INITIALIZED="true"
elif [ -d "/data" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_DATA_INIT_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$ENTRYPOINT_CONFIG_INIT_FILE" ]; then
  CONFIG_DIR_INITIALIZED="true"
elif [ -d "/config" ]; then
  echo "Initialized on: $INIT_DATE" >"$ENTRYPOINT_CONFIG_INIT_FILE"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ "$ENTRYPOINT_FIRST_RUN" != "no" ]; then
  # setup the smtp server
  __setup_mta
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ "$ENTRYPOINT_MESSAGE" = "yes" ] && __printf_space "40" "Container ip address is:" "$CONTAINER_IP4_ADDRESS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show configured listing processes
if [ "$ENTRYPOINT_MESSAGE" = "yes" ] && [ -n "$ENV_PORTS" ]; then
  show_port=""
  for port in $ENV_PORTS; do [ -n "$port" ] && show_port+="$(printf '%s ' "${port// /}") "; done
  __printf_space "40" "The following ports are open:" "$show_port"
  unset port show_port
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show message
__run_message
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# execute init script
if [ -f "/tmp/init" ]; then sh "/tmp/init"; fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Just start services
START_SERVICES="${START_SERVICES:-SYSTEM_INIT}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Begin options
case "$1" in
--help) # Help message
  echo 'Docker container for '$APPNAME''
  echo "Usage: $APPNAME [cron exec start init shell certbot ssl procs ports healthcheck backup command]"
  echo ""
  exit 0
  ;;

init)
  shift 1
  echo "Container has been Initialized"
  exit 0
  ;;

cron)
  shift 1
  __cron "$@" &
  exit
  ;;

backup) # backup data and config dirs
  shift 1
  save="${1:-$BACKUP_DIR}"
  backupExit=0
  date="$(date '+%Y%m%d-%H%M')"
  file="$save/$date.tar.gz"
  echo "Backing up /data /config to $file"
  sleep 1
  tar cfvz "$file" --exclude="$save" "/data" "/config" || backupExit=1
  backupExit=$?
  [ $backupExit -eq 0 ] && echo "Backed up /data /config has finished" || echo "Backup of /data /config has failed"
  exit $backupExit
  ;;

healthcheck) # Docker healthcheck
  healthStatus=0
  services="${SERVICES_LIST:-$@}"
  healthEnabled="${HEALTH_ENABLED:-}"
  healthPorts="${WEB_SERVER_PORTS:-}"
  healthEndPoints="${HEALTH_ENDPOINTS:-}"
  healthMessage="Everything seems to be running"
  services="${services//,/ }"
  [ "$healthEnabled" = "yes" ] || exit 0
  for proc in $services; do
    if [ -n "$proc" ]; then
      if ! __pgrep "$proc"; then
        echo "$proc is not running" >&2
        healthStatus=$((healthStatus + 1))
      fi
    fi
  done
  for port in $ports; do
    if [ -n "$(type -P netstat)" ] && [ -n "$port" ]; then
      netstat -taupln | grep -q ":$port " || healthStatus=$((healthStatus + 1))
    fi
  done
  for endpoint in $healthEndPoints; do
    if [ -n "$endpoint" ]; then
      __curl "$endpoint" || healthStatus=$((healthStatus + 1))
    fi
  done
  [ "$healthStatus" -eq 0 ] || healthMessage="Errors reported see: docker logs --follow $CONTAINER_NAME"
  [ -n "$healthMessage" ] && echo "$healthMessage"
  exit $healthStatus
  ;;

ports) # show open ports
  shift 1
  ports="$(__netstat -taupln | awk -F ' ' '{print $4}' | awk -F ':' '{print $2}' | sort --unique --version-sort | grep -v '^$' | grep '^' || echo '')"
  [ -n "$ports" ] && printf '%s\n%s\n' "The following are servers:" "$ports" | tr '\n' ' '
  exit $?
  ;;

procs) # show running processes
  shift 1
  ps="$(__ps axco command | grep -vE 'COMMAND|grep|ps' | sort -u || grep '^' || echo '')"
  [ -n "$ps" ] && printf '%s\n%s\n' "Found the following processes" "$ps" | tr '\n' ' '
  exit $?
  ;;

ssl) # setup ssl
  shift 1
  __create_ssl_cert
  exit $?
  ;;

certbot) # manage ssl certificate
  shift 1
  CERT_BOT_ENABLED="true"
  if [ "$1" = "create" ]; then
    shift 1
    __certbot "create"
  elif [ "$1" = "renew" ]; then
    shift 1
    __certbot "renew certonly --force-renew"
  else
    __exec_command "certbot" "$@"
  fi
  exit $?
  ;;

*/bin/sh | */bin/bash | bash | sh | shell) # Launch shell
  shift 1
  __exec_command "${@:-/bin/bash}"
  exit $?
  ;;

exec) # execute commands
  shift 1
  __exec_command "${@:-echo "No commands given"}"
  exit $?
  ;;

start) # show/start init scripts
  shift 1
  export PATH="/usr/local/etc/docker/init.d:$PATH"
  if [ $# -eq 0 ]; then
    scripts="$(ls -A "/usr/local/etc/docker/init.d")"
    [ -n "$scripts" ] && echo "$scripts" || echo "No scripts found in: /usr/local/etc/docker/init.d"
  elif [ "$1" = "all" ]; then
    shift $#
    echo "$$" >"/run/init.d/entrypoint.pid"
    __start_init_scripts "/usr/local/etc/docker/init.d"
  elif [ -f "/usr/local/etc/docker/init.d/$1" ]; then
    eval "/usr/local/etc/docker/init.d/$1"
  fi
  __no_exit
  exit $?
  ;;

*) # Execute primary command
  if [ $# -eq 0 ]; then
    if [ "$START_SERVICES" = "yes" ] || [ ! -f "/run/init.d/entrypoint.pid" ]; then
      echo "$$" >"/run/init.d/entrypoint.pid"
      __start_init_scripts "/usr/local/etc/docker/init.d"
      __no_exit
    fi
  else
    __exec_command "$@"
  fi
  exit $?
  ;;
esac
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end of entrypoint
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ex: ts=2 sw=2 et filetype=sh
