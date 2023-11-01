#!/bin/bash
echo
echo "Создаём директорию Archive для хранения бэкапов"
sudo mkdir -p /archive
echo "Архивируем папку /home и конфигурационные файлы (RDP,FTP,SSH)"
sudo tar -czpvf /archive/backup_`date +%Y-%m-%d`.tar.gz --directory /  /home /etc/ssh/sshd_config /etc/vsftpd/vsftpd.conf /etc/xrdp/xrdp.ini 
echo "Архивирование закончено"
