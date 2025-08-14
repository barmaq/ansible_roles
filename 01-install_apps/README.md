# Role: 01-install_apps

## Описание
Роль для установки базовых приложений и инструментов мониторинга на Debian/Ubuntu системах.

## Переменные

### monitoring_tools
Список инструментов для мониторинга сети и системы. По умолчанию:
```yaml
monitoring_tools:
  - fail2ban
  - iperf3
  - mtr
  - ethtool
  - tcpdump
  - duc
  - curl
  - arp-scan
  - htop
  - rsync
  - snmp
  - sysstat
```

## Пример использования
```yaml
- hosts: servers
  roles:
    - 01-install_apps
```

## Требования
- Ansible 2.9+
- Debian/Ubuntu система
- sudo права 