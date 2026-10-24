#!/bin/sh
set -e



FTP_PASSWORD="$(cat /run/secrets/ftp_password)"


# create the user only if it doesn't exist yet (restart-safe)
id "$FTP_USER" >/dev/null 2>&1 || adduser -D -h /var/www/html -G nobody "$FTP_USER"
echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

touch /var/log/vsftpd.log
tail -F /var/log/vsftpd.log &

exec vsftpd /etc/vsftpd/vsftpd.conf