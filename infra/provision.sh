#!/usr/bin/env bash
#
# Первичная настройка сервера Fluenta (Ubuntu 24.04).
# Идемпотентный: повторный запуск безопасен.
#
# Запуск от root на свежем сервере:
#   scp infra/provision.sh root@<ip>:/tmp/ && ssh root@<ip> 'bash /tmp/provision.sh <ваш-ssh-публичный-ключ-файл>'
#
# Секретов в этом файле нет и быть не должно — он лежит в публичном репозитории.

set -euo pipefail

DEPLOY_USER="${DEPLOY_USER:-deploy}"
APP_DIR="/opt/fluenta"

log() { printf '\n\033[1;36m▸ %s\033[0m\n' "$*"; }

if [[ $EUID -ne 0 ]]; then
	echo "Запускать от root." >&2
	exit 1
fi

# ─────────────────────────── Пакеты ───────────────────────────

log "Обновляю систему"
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get upgrade -y -qq
apt-get install -y -qq \
	ca-certificates curl gnupg ufw fail2ban unattended-upgrades \
	apt-listchanges needrestart

# ───────────────── Пользователь для деплоя ─────────────────

log "Настраиваю пользователя $DEPLOY_USER"
if ! id -u "$DEPLOY_USER" >/dev/null 2>&1; then
	adduser --disabled-password --gecos "" "$DEPLOY_USER"
fi
usermod -aG sudo "$DEPLOY_USER"

# Публичный ключ передаётся первым аргументом (путь к файлу) либо
# копируется из root, если сервер создавался с ключом.
mkdir -p "/home/$DEPLOY_USER/.ssh"
if [[ $# -ge 1 && -f "$1" ]]; then
	cat "$1" >>"/home/$DEPLOY_USER/.ssh/authorized_keys"
elif [[ -f /root/.ssh/authorized_keys ]]; then
	cat /root/.ssh/authorized_keys >>"/home/$DEPLOY_USER/.ssh/authorized_keys"
fi
sort -u -o "/home/$DEPLOY_USER/.ssh/authorized_keys" "/home/$DEPLOY_USER/.ssh/authorized_keys"
chown -R "$DEPLOY_USER:$DEPLOY_USER" "/home/$DEPLOY_USER/.ssh"
chmod 700 "/home/$DEPLOY_USER/.ssh"
chmod 600 "/home/$DEPLOY_USER/.ssh/authorized_keys"

if [[ ! -s "/home/$DEPLOY_USER/.ssh/authorized_keys" ]]; then
	echo "ОСТАНОВКА: у $DEPLOY_USER нет ни одного ключа — иначе после" >&2
	echo "отключения root-входа вы потеряете доступ к серверу." >&2
	exit 1
fi

# ──────────────────────── SSH hardening ────────────────────────

log "Ужесточаю SSH"
cat >/etc/ssh/sshd_config.d/99-fluenta.conf <<'EOF'
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
X11Forwarding no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
AllowAgentForwarding no
EOF
sshd -t && systemctl reload ssh

# ───────────────────────── Файрвол ─────────────────────────

log "Настраиваю UFW"
ufw --force reset >/dev/null
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 443/udp
ufw --force enable

# ───────────────────────── fail2ban ─────────────────────────

log "Настраиваю fail2ban"
cat >/etc/fail2ban/jail.local <<'EOF'
[DEFAULT]
bantime = 1h
findtime = 10m
maxretry = 5
backend = systemd

[sshd]
enabled = true
EOF
systemctl enable --now fail2ban
systemctl restart fail2ban

# ──────────────────── Автообновления ────────────────────

log "Включаю автоматические обновления безопасности"
cat >/etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
EOF
cat >/etc/apt/apt.conf.d/51unattended-upgrades-fluenta <<'EOF'
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
EOF
systemctl enable --now unattended-upgrades

# ────────────────────────── Docker ──────────────────────────

log "Ставлю Docker"
if ! command -v docker >/dev/null 2>&1; then
	install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
		gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	chmod a+r /etc/apt/keyrings/docker.gpg
	# Файл /etc/os-release есть только на целевом сервере — при локальной
	# проверке линтер его не видит, и это ожидаемо.
	# shellcheck disable=SC1091
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
		>/etc/apt/sources.list.d/docker.list
	apt-get update -qq
	apt-get install -y -qq docker-ce docker-ce-cli containerd.io \
		docker-buildx-plugin docker-compose-plugin
fi
usermod -aG docker "$DEPLOY_USER"

# ⚠️ Docker публикует порты в обход UFW. Единственный контейнер с
# внешними портами — Caddy (80/443), и это осознанно. Всё остальное
# не должно объявлять ports: наружу — см. infra/docker-compose.yml.
log "Ограничиваю Docker в обходе файрвола"
cat >/etc/docker/daemon.json <<'EOF'
{
  "iptables": true,
  "log-driver": "json-file",
  "log-opts": { "max-size": "10m", "max-file": "3" },
  "live-restore": true
}
EOF
systemctl restart docker

# ───────────────────────── Каталог ─────────────────────────

log "Готовлю $APP_DIR"
mkdir -p "$APP_DIR"
chown -R "$DEPLOY_USER:$DEPLOY_USER" "$APP_DIR"

log "Готово"
cat <<EOF

Дальше — вручную:
  1. Положить в $APP_DIR файл .env по образцу infra/.env.example (chmod 600).
  2. Скопировать туда docker-compose.yml, Caddyfile и каталог postgres-init/.
  3. Направить в Cloudflare DNS: api.fluenta.wiki и api-dev.fluenta.wiki на этот сервер.
  4. Проверить вход как $DEPLOY_USER ДО закрытия текущей сессии root.
  5. docker compose up -d

Проверка состояния:
  ufw status verbose
  fail2ban-client status sshd
  sshd -T | grep -E 'permitrootlogin|passwordauthentication'
EOF
