# Настройка GitHub Self-Hosted Runner с помощью Ansible

Этот проект предназначен для автоматической настройки GitHub Runner на удаленном сервере.

## Подготовка

### 1. Создание инвентаря
Файл `inventory.ini` игнорируется гитом. Выполните команду, чтобы создать его (замените данные на свои):

```bash
cd ansible/runner && cat <<EOF > inventory.ini
[vps]
runner ansible_host=95.163.240.110 ansible_user=root ansible_ssh_private_key_file=~/.ssh/my_server_key
EOF
```

---

## Переменные окружения (Терминал)
Перед запуском установите токен:

1. `GITHUB_REGISTRATION_TOKEN`: токен из GitHub (**Settings -> Actions -> Runners -> New self-hosted runner**).

---

## Команды для запуска

### Установка Runner и DeepSeek Harness (dsh)
Выполняется для полной настройки агента и CLI.

```bash
cd ansible/runner && \
export GITHUB_REGISTRATION_TOKEN="ТОКЕН_ИЗ_GITHUB" && \
ansible-playbook -i inventory.ini runner.yml \
  --tags github_runner,dsh -v
```

### Только установка DeepSeek Harness (dsh)
Если раннер уже настроен:
```bash
cd ansible/runner && \
ansible-playbook -i inventory.ini runner.yml \
  --tags dsh -v
```

## Проверка после установки

После успешного выполнения плейбука раннер работает как системная служба.

### Как проверить статус:
Зайдите на сервер и выполните одну из команд:
```bash
# Через скрипт раннера
sudo /opt/actions-runner/svc.sh status

# Через системный менеджер (имя сервиса может зависеть от конфигурации)
sudo systemctl status "actions.runner.*"
```
> **Внимание:** Вы устанавливаете **GitHub Runner**, а не GitLab Runner. Сервис называется `actions.runner.<owner>-<repo>.<hostname>.service`, поэтому `systemctl status gitlab-runner` работать не будет. Используйте `systemctl list-units "actions.runner.*"` чтобы найти точное имя.

### Где находятся файлы:
Все файлы раннера находятся в директории:
`/opt/actions-runner`

---

## Отладка
- **Permission denied**: проверьте правильность путей к SSH-ключам.
- **Connection refused**: подождите 1-2 минуты (защита сервера от частых подключений).
- **Not Found (404)**: обновите токен регистрации в GitHub.
- **Service not found**: убедитесь, что вы передаете `github_runner_user` при установке сервиса (Ansible делает это автоматически).
