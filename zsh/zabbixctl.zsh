:zabbix:switch-on-call() {
    local next="${1:-$USER}"
    local current=$(
        zabbixctl -G NGS_ADM_WC_MAIN_SEND 2>/dev/null \
            | awk '{print $3}'
    )

    printf "Switching pager duty: %s -> %s\n" "$current" "$next"

    {
        for group in {NGS_ADM_WC_MAIN_SEND,HTTP_NGS_SEND,HTTP_HSDRN_SEND}; do
            zabbixctl -f -G "$group" -a "$next"
            zabbixctl -f -G "$group" -r "$current"
        done

        zabbixctl -f -G NGS_ADM_WC_BACKUP_SEND -a "$current"
        zabbixctl -f -G NGS_ADM_WC_BACKUP_SEND -r "$next"
    } >/dev/null 2>/dev/null

    printf "---\n"
    for group in {NGS_ADM_WC_MAIN_SEND,HTTP_NGS_SEND,HTTP_HSDRN_SEND,NGS_ADM_WC_BACKUP_SEND}; do
        zabbixctl -f -G "$group" 2>/dev/null
    done
}
