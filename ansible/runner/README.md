# Настройка GitHub Self-Hosted Runner с помощью Ansible

Этот проект предназначен для автоматической настройки GitHub Runner на удаленном сервере.

## Подготовка

### 1. Создание инвентаря
Файл `inventory.ini` игнорируется гитом. Выполните команду (находясь в корне проекта или в папке `ansible/runner`), чтобы создать его:

```bash
cd ansible/runner && cat <<EOF > inventory.ini
[vps]
runner ansible_host=95.163.240.110 ansible_user=debian ansible_ssh_private_key_file=~/.ssh/my_server_key_user
EOF
```
**Что подменить:**
- `95.163.240.110` -> публичный IP вашего сервера.
- `~/.ssh/my_server_key_user` -> путь к ПРИВАТНОМУ ключу на вашем ПК для пользователя `debian`.

### 2. Настройка GitHub (defaults)
В файле `ansible/runner/roles/github_runner/defaults/main.yml` укажите:
- `github_owner`: ваш логин на GitHub.
- `github_repo`: имя репозитория.

---

## Переменные окружения (Терминал)
Перед запуском команд установите следующие переменные:

1. `USER_AUTH_KEY_PATH`: путь к **публичному** ключу (напр. `~/.ssh/id_rsa.pub`), который будет добавлен на сервер для пользователя `debian`.
2. `GITHUB_REGISTRATION_TOKEN`: токен из GitHub (**Settings -> Actions -> Runners -> New self-hosted runner**).

---

## Команды для запуска

### Шаг 1: Создание пользователя (от имени root)
Выполняется один раз для настройки доступа.
```bash
cd ansible/runner && \
export USER_AUTH_KEY_PATH="~/.ssh/my_server_key_user.pub" && \
ansible-playbook -i inventory.ini runner.yml \
  -e "ansible_user=root ansible_ssh_private_key_file=~/.ssh/my_server_key" \
  --tags user_setup -v
```

### Шаг 2: Установка Runner (от имени debian)
Выполняется для установки и регистрации агента.
```bash
cd ansible/runner && \
export GITHUB_REGISTRATION_TOKEN="ТОКЕН_ИЗ_GITHUB" && \
ansible-playbook -i inventory.ini runner.yml \
  --tags github_runner -v
```

## Отладка
Если возникли проблемы с подключением, используйте флаг `-vvv` для получения подробных логов SSH.
