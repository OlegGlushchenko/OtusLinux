#!/bin/bash

#Подготавливаем систему для сборки своего пакета
yum install -y \
redhat-lsb-core \
wget \
rpmdevtools \
rpm-build \
createrepo \
yum-utils

#Загружаем исходники пакета NGINX
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm

#Устанавливаем пакет
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

#Загружаем исходники openssl
wget https://www.openssl.org/source/latest.tar.gz

#Разархивируем в директорию /usr/lib
tar -xvf latest.tar.gz --directory /usr/lib

#Ставим все зависимости nginx
yum-builddep /root/rpmbuild/SPECS/nginx.spec -y

#Изменяем spec файл (меняем --with-debug на /usr/lib/openssl-1.1.1a)
sed -i 's|--with-debug|--with-openssl=/usr/lib/openssl-1.1.1a|' /root/rpmbuild/SPECS/nginx.spec

#Собираем свой пакет
rpmbuild -bb /root/rpmbuild/SPECS/nginx.spec

#Устанавливаем собранный пакет
yum localinstall -y /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm

#Пакет установлен. Для прозрачности настроим в NGINX доступ к листингу каталога добавив "autoindex on" после строчки "index  index.html index.htm"
sed -i '/index  index.html index.htm;/a autoindex on;' /etc/nginx/conf.d/default.conf

#Запускаем nginx
systemctl enable --now nginx



#Приступаем к созданию своего репозитория.
#Создаем директорию repo в директории для статики NGINX
mkdir /usr/share/nginx/html/repo

#Копируем собранный RPM 
cp /root/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

#Загружаем Percona-Server в директорию создаваемого репозитория
wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm

#Инициализируем репозиторий
createrepo /usr/share/nginx/html/repo/

#Добавим созданный репозиторий в /etc/yum.repos.d
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

#Устанавливаем percona-server из локального репозитория
yum install percona-release -y