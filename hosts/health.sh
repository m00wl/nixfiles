#!/usr/bin/env bash

declare -A HOST_SERVICES=(
    [data]="nixos-upgrade borgbackup-job-nextcloud nextcloud-cron"
    [laforge]="nixos-upgrade nginx"
    [seven]="nixos-upgrade"
    [sisko]="nixos-upgrade dnsmasq fail2ban ddclient"
    [troi]="nixos-upgrade borgbackup-job-vaultwarden vaultwarden"
)

readonly C_RED=$'\e[1;31m'
readonly C_GRN=$'\e[1;32m'
readonly C_RST=$'\e[0m'

fetch() {
    echo -e "HOST\tSERVICE\tSTATE\tSUBSTATE\tLAST-CHANGE"
    echo -e "----\t-------\t-----\t--------\t-----------"

    for host in $(printf '%s\n' "${!HOST_SERVICES[@]}" | sort); do
        local services="${HOST_SERVICES[$host]}"

        local ssh_cmd="
            for s in $services; do
                echo -en \"$host\t\$s\t\"
                systemctl show -p ActiveState,SubState,StateChangeTimestamp --value \"\$s\" | paste -s
            done
        "

        ssh -q -o ConnectTimeout=5 -o BatchMode=yes "m00wl@$host" "$ssh_cmd" ||
            echo -e "$host\t-\tSSH CONNECTION FAILED\t-\t-"
    done
}

colorize() {
    sed -E \
        -e "s/\b(active|running|exited)\b/${C_GRN}\1${C_RST}/g" \
        -e "s/\b(failed)\b/${C_RED}\1${C_RST}/g" \
        -e "s/SSH CONNECTION FAILED/${C_RED}&${C_RST}/g"
}

fetch | column -t -s $'\t' | colorize
