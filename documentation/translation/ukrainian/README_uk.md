# Automatic virtual host setup
Простий bash скрипт, розроблений для автоматичного створення та налаштування віртуальних хостів на сервері apache2.

## Встановлення
Для того, щоб почати використовувати скрипт, потрібно його завантажити
### GitHub
```
$ git clone https://github.com/LogansUA/auto-virtual-host-setup.git
```

## Документація
### Використання
Щоб виконати скрипт, його необхідно запустити з терміналу


**Команда**
```
$ bash avhs.sh
```
**Опис**

Скрипт вирішує проблему створення віртуального хоста та дає змогу швидко розгорнути вибраний проект.

**Приклад**
```
Project name (new_project): project
Server path (/var/www):
Host path (/etc/hosts):
IP host (127.0.0.1):

Do you want to create some type of project? [Y/N]: y
Insert type of project: symfony
```

**Результат**
* Створено папку `project` за адресою `/var/www`;
* Створено `project.conf` за адресою `/etc/apache2/sites-available`;
* Активовано `project.conf`, що в свою чергу створило віртуальний хост за адресою `http://project/` (`http://127.0.0.1/`);
* Створено та налаштовано новий проект `symfony` за адресою `/var/www/project`.

**Алгоритм**

При виконанні скрипту виконуються такі дії:
* **введення параметрів** необхідних для створення віртуального хоста (`назва проекту`, `шлях до серверу`, `шлях до файлу хостів`, `ip хоста`, `тип проекту` - якщо дан згоду).

  Якщо параметри не введені то використовуються **стандартні значення** (`new_project`, `/var/www`, `/etc/hosts`, `127.0.0.1`);

* **створення папки для проекту** за визначеними значеннями;

* **створення файлу конфігурації** серверу за стандартною адресою конфігураційних файлів `apache2` (`/etc/apache2/sites-available`) з назвою проекту;

* **активація файлу з налаштуваннями** (`a2ensite`);

* **дописування ip хосту** в визначений файл хостів;

* **перезавантаження `apache2` серверу**;

* **розгортання проекту** в залежності від введеного типу.

## Типи проектів
Скрипт має змогу розгорнути декілька проектів:
* [Symfony](https://github.com/LogansUA/auto-virtual-host-setup/blob/develop/documentation/translation/ukrainian/types/symfony.md);
* [OpenCart]((https://github.com/LogansUA/auto-virtual-host-setup/blob/develop/documentation/translation/ukrainian/types/opencart.md));
* [WordPress]((https://github.com/LogansUA/auto-virtual-host-setup/blob/develop/documentation/translation/ukrainian/types/wordpress.md)).

## Контакти
* Для надання певної допомоги та співпраці, ознайомтесь з сторінкою [співробітництво](https://github.com/LogansUA/auto-virtual-host-setup/blob/develop/documentation/translation/ukrainian/contribution.md);
* Для того, щоб зв'язатись з автором, пишіть за адресою `logansoleg@gmail.com`.
