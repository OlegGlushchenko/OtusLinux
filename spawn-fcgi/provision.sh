#!/bin/bash

#Устанавливаем репозиторий, fcgi и nginx
yum install -y epel-release
yum install -y spawn-fcgi

#Инициализируем запуск spawn-fcgi через unit
#Копируем настройки для запуска spawn-fcgi - сервиса
cp /home/vagrant/spawn-fcgi/spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service
#Копируем файл настроек spawn-fcgi 
cp /home/vagrant/spawn-fcgi/spawn-fcgi.conf /etc/sysconfig/spawn-fcgi
#Запускаем сервис
systemctl enable --now spawn-fcgi.service
