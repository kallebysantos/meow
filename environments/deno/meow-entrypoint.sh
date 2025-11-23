#!/sbin/openrc-run

command="/usr/bin/deno"
command_args="serve --host 0.0.0.0 --port 8000 /app/index.ts"
command_user="root"
pidfile="/var/run/deno-server.pid"

depend() { 
  after networking
}

start_pre() {
  mkdir -p /var/run/deno-server
}

start() {
    ebegin "Starting Deno server"
    start-stop-daemon --start --quiet --background \
        --pidfile "$pidfile" \
        --make-pidfile \
        --exec "$command" -- $command_args
    eend $?
}

stop() {
    ebegin "Stopping Deno server"
    start-stop-daemon --stop --pidfile "$pidfile"
    eend $?
}
