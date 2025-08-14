# SSH Keys Management Role

Ansible роль для управления SSH ключами и настройки SSH конфигурации на серверах.

## Описание

Эта роль выполняет следующие задачи:
- Создает директорию `~/.ssh` с правильными правами доступа
- Добавляет публичные SSH ключи из указанной директории
- Удаляет отозванные ключи
- Настраивает SSH для запрета парольной аутентификации root
- Валидирует конфигурацию SSH
- Перезапускает SSH сервис при необходимости

## Структура директорий

```
/root/ansible/
├── public_keys/           # Публичные ключи для добавления
│   ├── key1.pub
│   ├── key2.pub
│   └── revoked/          # Отозванные ключи для удаления
│       ├── revoked1.pub
│       └── revoked2.pub
└── roles/
    └── 00-keys/          # Роль
        ├── tasks/
        ├── handlers/
        ├── defaults/
        └── meta/
```

## Требования

- Ansible 2.9+
- Доступ root на целевых серверах
- SSH ключи должны быть в формате OpenSSH

## Переменные

### Обязательные переменные

Нет обязательных переменных, все имеют значения по умолчанию.

### Переменные по умолчанию

```yaml
# SSH конфигурация
sshd_config: /etc/ssh/sshd_config
ssh_service: sshd

# Директории с SSH ключами
ssh_keys_public_dir: "/root/ansible/public_keys"
ssh_keys_revoked_dir: "/root/ansible/public_keys/revoked"

# Настройки SSH
ssh_permit_root_login: "prohibit-password"

# пользователь для добавления публичных ключей
target_user: "{{ ansible_user | default('root') }}"
```




### Переменные для переопределения

Вы можете переопределить любую из переменных по умолчанию:

```yaml
# В playbook или group_vars
ssh_keys_public_dir: "/custom/path/to/keys"
ssh_keys_revoked_dir: "/custom/path/to/revoked"
ssh_permit_root_login: "no"  # Полностью запретить root login
```

## Использование

### 1. Подготовка ключей

Создайте структуру директорий:
```bash
mkdir -p /root/ansible/public_keys/revoked
```

Поместите публичные ключи в `/root/ansible/public_keys/`:
```bash
# Пример добавления ключа
cp ~/.ssh/id_rsa.pub /root/ansible/public_keys/user1.pub
cp ~/.ssh/another_key.pub /root/ansible/public_keys/user2.pub
```

Поместите отозванные ключи в `/root/ansible/public_keys/revoked/`:
```bash
cp ~/.ssh/revoked_key.pub /root/ansible/public_keys/revoked/
```

### 2. Использование в playbook

```yaml
---
- hosts: all
  become: yes
  roles:
    - 00-keys
```

### 3. Использование с кастомными переменными

```yaml
---
- hosts: all
  become: yes
  vars:
    ssh_keys_public_dir: "/custom/keys"
    ssh_keys_revoked_dir: "/custom/keys/revoked"
  roles:
    - 00-keys
```

### 4. Использование из Git

```bash
# Клонирование роли
git clone https://github.com/your-username/ansible-ssh-keys-role.git roles/00-keys

# Использование в playbook
---
- hosts: all
  become: yes
  roles:
    - 00-keys
```

## Теги

Роль поддерживает следующие теги:
- `restart` - принудительный перезапуск SSH сервиса

```yaml
---
- hosts: all
  become: yes
  roles:
    - 00-keys
  tags: [ssh, keys]
```

## Безопасность

- Роль настраивает `PermitRootLogin prohibit-password` по умолчанию
- Все ключи проверяются на валидность
- SSH конфигурация валидируется перед применением
- Права доступа к `~/.ssh` устанавливаются как 700

## Примеры

### Добавление нового ключа

1. Скопируйте публичный ключ в директорию:
```bash
cp ~/.ssh/new_user.pub /root/ansible/public_keys/
```

2. Запустите playbook:
```bash
ansible-playbook -i inventory site.yml
```

### Отзыв ключа

1. Переместите ключ в директорию revoked:
```bash
mv /root/ansible/public_keys/user1.pub /root/ansible/public_keys/revoked/
```

2. Запустите playbook:
```bash
ansible-playbook -i inventory site.yml
```

## Troubleshooting

### Проблема: "Permission denied" при копировании ключей
**Решение:** Убедитесь, что у пользователя есть права на чтение директории с ключами.

### Проблема: SSH не перезапускается
**Решение:** Проверьте логи SSH и убедитесь, что конфигурация валидна.

### Проблема: Ключи не добавляются
**Решение:** Проверьте формат ключей - они должны быть в формате OpenSSH.

## Лицензия

MIT License 
