#!/bin/bash

#Копируем файл настроек (параметры для поиска: директория поиска и ключевое слово)
cp /vagrant/servicekey/servicekey.conf /etc/sysconfig/servicekey

#Копируем настройки таймера, по которому будет запускаться наш скрипт поиска
cp /vagrant/servicekey/servicekey.timer /etc/systemd/system/servicekey.timer

#Копируем настройки для запуска сервиса (сервис запускается по oneshot - отработал - "умер". Воскресает по таймеру)
cp /vagrant/servicekey/servicekey.service /etc/systemd/system/servicekey.service

#Копируем скрипт для поиска ключевого слова
cp /vagrant/servicekey/servicekey.sh /usr/bin/servicekey.sh

#Делаем скрипт исполняемым
chmod +x /usr/bin/servicekey.sh

#Запускаем сервис
systemctl enable --now servicekey.timer