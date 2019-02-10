#!/bin/bash

#Копируем файл в систему. В файле полный набор прав (как у root) соотнесен с пользователем vagrant (подопытный)
cp /home/vagrant/I_am_rooot/caps /etc/security/capability.conf

#Добавляем в сценарий модуль (pam_cap.so) для работы с capability
cp /home/vagrant/I_am_rooot/su /etc/pam.d/su