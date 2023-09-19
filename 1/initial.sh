#!/bin/bash
echo 
echo "1. Проверка установки репозитория Docker"
if [ `sudo dnf repolist | awk '{print$1}' | grep docker-ce-stable` ]; then 
	echo "Репозиторий уже установлен"
else
	echo "Репозиторий не установлен"
	echo "Установка репозитория Docker..."
	sudo dnf install -y dnf-utils
	sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
fi
 echo "Удаление старого пакета Docker"
 sudo dnf remove -y podman runc
 echo "Установка пакета Docker"
 sudo dnf install -y docker-ce docker-ce-cli containerd.io
 echo "Добавление службы в автозагрузку и запуск Docker"
 sudo systemctl enable --now docker.service
 echo "Docker установлен"


echo 
echo "2. Обновляем пакетный менеджер"
echo "Очистка кэша репозиториев"
sudo dnf clean all
echo "Загрузка и обновление пакетов"
sudo dnf upgrade -y

echo 
echo "3. Установка веб-сервера Apache"
echo "Установка пакета Apache"
sudo dnf install -y httpd
echo "Добавление службы в автозагрузку и запуск веб-сервера Apache"
sudo systemctl enable --now httpd.service
echo "Добавление службы веб-сервера в исключения файервола"
if [[ `sudo firewall-cmd --list-services | grep http[^s]` ]]; then
	echo "Исключение уже добавлено"
else
	sudo firewall-cmd --add-service=http --permanent
	sudo firewall-cmd --reload
fi
echo "Apache установлен"

echo
echo "4. Установка Python"
echo "Установка пакета Python"
sudo dnf install -y python
echo "Python установлен"

echo
echo "5. Установка SSH-сервера"
echo "Установка пакета OpenSSH"
sudo dnf install -y openssh openssh-server
echo "Добавление службы в автозагрузку и запуск SSH-сервера"
sudo systemctl enable --now sshd.service
echo "Добавление службы SSH-сервера в исключения файервола"
if [[ `sudo firewall-cmd --list-services | grep ssh` ]]; then
	echo "Исключение уже добавлено"
else
	sudo firewall-cmd --add-service=ssh --permanent
	sudo firewall-cmd --reload
fi
echo "SSH-сервер установлен"

echo
echo "6. Установка MySQL-сервера"
echo "Установка пакета MySQL"
sudo dnf install -y mysql mysql-server
echo "Добавление службы в автозагрузку и запуск MySQL-сервера"
sudo systemctl enable --now mysqld.service
echo "Добавление службы MySQL-сервера в исключения файервола"
if [[ `sudo firewall-cmd --list-services | grep mysql` ]]; then
	echo "Исключение уже добавлено"
else
	sudo firewall-cmd --add-service=mysql --permanent
	sudo firewall-cmd --reload
fi
echo "MySQL-сервер установлен"

echo
echo "7. Отключение SELinux"
echo "Текущий статус SELinux:"
SELINUX_STATE=$(sudo getenforce)
echo $SELINUX_STATE
if [ $SELINUX_STATE == 'Disabled' ]; then
	echo "Уже отключён"
else
	echo "Отключаем..."
	sudo setenforce 0	
	sudo sed -c -i "s/\SELINUX=.*/SELINUX=disabled/" /etc/selinux/config
	echo "SELinux отключён"
fi

echo
echo "8. Установка PHP 8"
echo "Установка пакета PHP и менеджер процессов PHP-FPM"
sudo dnf install -y php php-fpm
echo "Активация модуля PHP 8.1"
sudo dnf module reset php -y
sudo dnf module enable php:8.1 -y
sudo dnf module install php:8.1 -y
echo "Добавление в автозагрузку и запуск менеджер процессов PHP-FPM"
sudo systemctl enable --now php-fpm.service
echo "PHP 8 установлен"

echo
echo "9. Установка RPD-сервера"
echo "Установка пакета EPEL"
sudo dnf install -y epel-release
echo "Установка пакета xRDP"
sudo dnf install -y xrdp
echo "Добавление службы в автозагрузку"
sudo systemctl enable --now xrdp.service
echo "Добавление службы RDP-сервера в исключения файервола"
if [[ `sudo firewall-cmd --list-services | grep rdp` ]]; then
	echo "Исключение уже добавлено"
else
	sudo firewall-cmd --add-service=rdp --permanent
	sudo firewall-cmd --reload
fi
echo "RPD-сервер установлен"

echo
echo "10. Установка FTP-сервера"
echo "Установка пакета vsftpd"
sudo dnf install -y vsftpd
echo "Добавление службы в автозагрузку"
sudo systemctl enable --now vsftpd.service
echo "Добавление службы FTP-сервера в исключения файервола"
if [[ `sudo firewall-cmd --list-services | grep ftp` ]]; then
	echo "Исключение уже добавлено"
else
	sudo firewall-cmd --add-service=ftp --permanent
	sudo firewall-cmd --reload
fi
echo "FTP-сервер установлен"
