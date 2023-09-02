#!/bin/bash
echo
echo "Отправляем письмо root"
sudo logwatch --detail High --mailto root --service vsftpd sshd --range yesterday
