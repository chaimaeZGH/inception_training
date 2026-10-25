#!/bin/sh
set -e

FTP_PASSWORD="$(cat /run/secrets/ftp_password)"


id "$FTP_USER" >/dev/null 2>&1 || adduser -D -h /var/www/html -G nobody "$FTP_USER"
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd


echo "$FTP_USER" > /etc/vsftpd.userlist
mkdir -p /var/run/vsftpd/empty

chown -R nobody:nobody /var/www/html
chmod -R g+w /var/www/html

touch /var/log/vsftpd.log
tail -F /var/log/vsftpd.log &

exec vsftpd /etc/vsftpd/vsftpd.conf