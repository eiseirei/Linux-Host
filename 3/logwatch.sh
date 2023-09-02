#!/bin/bash
echo
echo "Отправляем письмо root"
logwatch --detail High --mailto root --service vsftpd sshd --range today