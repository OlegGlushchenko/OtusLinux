#!/bin/bash

#Копируем файл с конфигом контроля времени (каждый выходные)
cp /home/vagrant/weekend/time.conf /etc/security/time.conf

#Копируем измененный сценарий
cp /home/vagrant/weekend/login /etc/pam.d/login