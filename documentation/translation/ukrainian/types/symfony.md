# Розгортання проекту Symfony
## Приклад
```
$ bash avhs.sh
Project name (new_project): symfony-project
Server path (/var/www):
Host path (/etc/hosts):
IP host (127.0.0.1):

Do you want to create some type of project? [Y/N]: y
Insert type of project: symfony
```
## Результат
* Створено папку `symfony-project` за адресою `/var/www`;

* Створено `symfony-project.conf` за адресою `/etc/apache2/sites-available`:

```
<VirtualHost *:80>
 	ServerName symfony-project
 	ServerAdmin webmaster@localhost
 	DocumentRoot /var/www/symfony-project/web
 	<Directory /var/www/symfony-project/web>
 		Options Indexes FollowSymLinks MultiViews
 		AllowOverride All
 		Order allow,deny
 		allow from all
 	</Directory>
</VirtualHost>

```
* Активовано `symfony-project.conf` (`http://symfony-project/`, `http://127.0.0.1/`);

* Дописано ip адресу локального хосту в файл `/etc/hosts`:

```
...
127.0.0.1 symfony-project
...
```

* Створено новий проект `symfony` за адресою `/var/www/symfony-project`;

* Закріплено необхідні права:

```
HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX /var/www/symfony-project/app/cache /var/www/symfony-project/app/logs
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX /var/www/symfony-project/app/cache /var/www/symfony-project/app/logs
```
