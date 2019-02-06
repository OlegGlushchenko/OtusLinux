#!/bin/bash

#Ставим httpd apache
yum install -y httpd

#Удаляем 80 порт из стандартного конфига апача
sed -i '/Listen 80/d' /etc/httpd/conf/httpd.conf

#Копируем unit-файл для запуска сервисов
cp /home/vagrant/httpd/httpd@.service /etc/systemd/system
#Копируем настройки конфигов инстансов. Конфиги отличаются друг от друга только портами и PID-файлами
cp /home/vagrant/httpd/httpd{1,2}.conf /etc/httpd/conf/

#Запускаем инстансы
systemctl enable --now httpd@httpd1.service
systemctl enable --now httpd@httpd2.service