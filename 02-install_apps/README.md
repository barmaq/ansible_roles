# 02-install_apps

Роль для установки приложений и Docker на Debian/Ubuntu системы.

## Описание

Эта роль устанавливает:
- Инструменты мониторинга сети и системы
- Docker Engine с официального репозитория
- Docker Compose как плагин
- Docker Buildx плагин

## Требования

- Ansible 2.9+
- Debian/Ubuntu система
- Привилегии sudo

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

### docker_required_packages
Пакеты, необходимые для установки Docker. По умолчанию:
```yaml
docker_required_packages:
  - apt-transport-https
  - ca-certificates
  - gnupg
  - lsb-release
```

### docker_packages
Пакеты Docker для установки. По умолчанию:
```yaml
docker_packages:
  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-buildx-plugin
  - docker-compose-plugin
```

## Использование

### Базовое использование
```yaml
- hosts: servers
  roles:
    - 02-install_apps
```

### С кастомными переменными
```yaml
- hosts: servers
  vars:
    monitoring_tools:
      - htop
      - curl
      - rsync
  roles:
    - 02-install_apps
```

## Что устанавливается

### Инструменты мониторинга
- **fail2ban** - защита от брутфорс атак
- **iperf3** - тестирование пропускной способности сети
- **mtr** - диагностика сети
- **ethtool** - настройка сетевых интерфейсов
- **tcpdump** - анализ сетевого трафика
- **duc** - анализ использования диска
- **curl** - HTTP клиент
- **arp-scan** - сканирование ARP
- **htop** - интерактивный просмотрщик процессов
- **rsync** - синхронизация файлов
- **snmp** - протокол управления сетью
- **sysstat** - системная статистика

### Docker
- **Docker Engine** - контейнеризация приложений
- **Docker CLI** - командная строка Docker
- **containerd** - среда выполнения контейнеров
- **Docker Buildx** - расширенные возможности сборки
- **Docker Compose** - оркестрация многоконтейнерных приложений

## После установки

После выполнения роли:
1. Docker будет установлен и запущен
2. Текущий пользователь будет добавлен в группу docker
3. Docker Compose будет доступен как `docker compose`
4. Все инструменты мониторинга будут установлены

## Проверка установки

```bash
# Проверка Docker
docker --version
docker compose version

# Проверка инструментов
htop --version
iperf3 --version
```

## Лицензия

MIT 