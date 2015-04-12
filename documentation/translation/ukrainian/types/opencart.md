# Розгортання проекту OpenCart
## Приклад
```
$ bash avhs.sh
Project name (new_project): opencart-project
Server path (/var/www):
Host path (/etc/hosts):
IP host (127.0.0.1):

Do you want to create some type of project? [Y/N]: y
Insert type of project: opencart
```
## Результат
* Створено папку `opencart-project` за адресою `/var/www`;

* Створено `opencart-project.conf` за адресою `/etc/apache2/sites-available`:

```
<VirtualHost *:80>
 	ServerName opencart-project
 	ServerAdmin webmaster@localhost
 	DocumentRoot /var/www/opencart-project
 	<Directory /var/www/opencart-project>
 		Options Indexes FollowSymLinks MultiViews
 		AllowOverride All
 		Order allow,deny
 		allow from all
 	</Directory>
</VirtualHost>

```
* Активовано `opencart-project.conf` (`http://opencart-project/`, `http://127.0.0.1/`);

* Дописано ip адресу локального хосту в файл `/etc/hosts`:

```
...
127.0.0.1 opencart-project
...
```

* Завантажено `opencart` (`opencart-XXX.tar.gz`, де `XXX` остання версія);

* Розгорнуто `opencart`;

* Переіменовано `config-dist.php` та `admin/config-dist.php` (`config.php` та `admin/config.php`).
