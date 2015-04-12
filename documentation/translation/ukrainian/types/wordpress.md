# Розгортання проекту WordPress
## Приклад
```
$ bash avhs.sh
Project name (new_project): wordpress-project
Server path (/var/www):
Host path (/etc/hosts):
IP host (127.0.0.1):

Do you want to create some type of project? [Y/N]: y
Insert type of project: wordpress
```
## Результат
* Створено папку `wordpress-project` за адресою `/var/www`;

* Створено `wordpress-project.conf` за адресою `/etc/apache2/sites-available`:

```
<VirtualHost *:80>
 	ServerName wordpress-project
 	ServerAdmin webmaster@localhost
 	DocumentRoot /var/www/wordpress-project
 	<Directory /var/www/wordpress-project>
 		Options Indexes FollowSymLinks MultiViews
 		AllowOverride All
 		Order allow,deny
 		allow from all
 	</Directory>
</VirtualHost>

```
* Активовано `wordpress-project.conf` (`http://wordpress-project/`, `http://127.0.0.1/`);

* Дописано ip адресу локального хосту в файл `/etc/hosts`:

```
...
127.0.0.1 wordpress-project
...
```

* Завантажено `wordpress` (`latest.tar.gz`);

* Розгорнуто `wordpress`.
