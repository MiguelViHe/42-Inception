#!/bin/bash

# Variables de entorno
FTP_USER=${FTP_USER:-"ftpuser"} # Usuario FTP, si no se define se usa por defecto "ftpuser"
FTP_USER_PASS=$(cat ${FTP_USER_PASSWORD_FILE}) # Contraseña del usuario FTP, leída desde el archivo

service vsftpd start

# Add the USER, change his password and declare him as the owner of wordpress folder and all subfolders

adduser ${FTP_USER} --disabled-password

echo "${FTP_USER}:${FTP_USER_PASS}" | /usr/sbin/chpasswd

echo "${FTP_USER}" | tee -a /etc/vsftpd.userlist


mkdir /home/${FTP_USER}/ftp


chown nobody:nogroup /home/${FTP_USER}/ftp
chmod a-w /home/${FTP_USER}/ftp

mkdir /home/${FTP_USER}/ftp/files
chown ${FTP_USER}:${FTP_USER} /home/${FTP_USER}/ftp/files

sed -i -r "s/#write_enable=YES/write_enable=YES/1"   /etc/vsftpd.conf
sed -i -r "s/#chroot_local_user=YES/chroot_local_user=YES/1"   /etc/vsftpd.conf

echo "
local_enable=YES
allow_writeable_chroot=YES
pasv_enable=YES
local_root=/home/ftpuser/ftp
pasv_min_port=40000
pasv_max_port=40005
userlist_file=/etc/vsftpd.userlist" >> /etc/vsftpd.conf

service vsftpd stop


/usr/sbin/vsftpd