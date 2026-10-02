# Bash QOL for the Ubuntu servers (goobot). Ubuntu's stock ~/.bashrc sources this file,
# so the distro .bashrc stays untouched. Install: `stow bash` from ~/dotfiles.

export SUDO_EDITOR="nvim"
export VISUAL="nvim"
export EDITOR="nvim"

myu() {
    sudo apt update
    sudo apt upgrade -y
}
alias syu='myu'

# SES production-access check. Needs ses:GetAccount, which goobot's send-only role doesn't
# have; run it from a machine with admin AWS credentials.
checkstatus() {
    aws sesv2 get-account --region us-east-1 | grep ProductionAccessEnabled
}

# Discord bots, supervised by pm2 (restart on crash and reboot).
#   basic = ~/void/basicbot      (pm2 name: basicbot)
#   oub   = ~/oubliette/basicbot (pm2 name: oubliette)
bot() {
    local BASIC_DIR="/home/ubuntu/void/basicbot"
    local OUB_DIR="/home/ubuntu/oubliette/basicbot"

    _bot_names() {
        case "$1" in
            basic) echo basicbot ;;
            oub)   echo oubliette ;;
            all)   echo basicbot oubliette ;;
            *)     return 1 ;;
        esac
    }

    _bot_dir() {
        case "$1" in
            basic) echo "$BASIC_DIR" ;;
            oub)   echo "$OUB_DIR" ;;
            *)     return 1 ;;
        esac
    }

    local names dir
    case "$1" in
        status)
            pm2 jlist | python3 -c '
import json, sys, time
for p in json.load(sys.stdin):
    name, pid, e = p["name"], p["pid"], p["pm2_env"]
    if name in ("basicbot", "oubliette"):
        status, restarts = e["status"], e["restart_time"]
        up = int(time.time() - e["pm_uptime"] / 1000) if status == "online" else 0
        print(f"{name:<10} {status:<8} pid {pid:<8} up {up // 3600}h{up % 3600 // 60:02d}m  restarts {restarts}")
'
            ;;
        start|stop|restart)
            # word-split intentionally: "all" is two pm2 names
            names=$(_bot_names "$2") || { echo "Usage: bot $1 basic|oub|all"; return 1; }
            pm2 "$1" $names
            ;;
        deploy)
            git -C "$OUB_DIR" pull
            ;;
        logs)
            # -F follows across log rotation; the bot's own rotating log survives restarts.
            dir=$(_bot_dir "$2") || { echo "Usage: bot logs basic|oub"; return 1; }
            tail -F "$dir/logs/basicbot.log"
            ;;
        errors)
            dir=$(_bot_dir "$2") || { echo "Usage: bot errors basic|oub"; return 1; }
            tail -n 50 "$dir/logs/errors.log"
            ;;
        out)
            # Raw stdout/stderr (pm2 captures it now), including anything that dies before
            # logging starts.
            names=$(_bot_names "$2") || { echo "Usage: bot out basic|oub"; return 1; }
            pm2 logs "$names" --raw
            ;;
        *)
            echo "Usage: bot {status|start|stop|restart|deploy|logs|errors|out}"
            ;;
    esac
}

export PATH="$HOME/.local/bin:$PATH"
