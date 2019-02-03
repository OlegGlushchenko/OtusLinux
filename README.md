# OtusLinux_Homework_5.
Что сделано:
- Написать скрипт для крона, который раз в час (настраивается в кроне) присылает на заданную почту (прописывается в скрипте)
    - X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
    - Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
    - все ошибки c момента последнего запуска
    - список всех кодов возврата с указанием их кол-ва с момента последнего запуска
    - в письме прописан обрабатываемый временной диапазон (указано время с которого начинается обработка)
    - Реализована защита от мультизапуска

Как проверить:
- В скрипте необходимо прописать пути до файлов логов (т.к. задача учебная и логов nginx у меня нет, то тренировался "на кошках" - файлах - примерах. По умолчанию пути прописаны до этих файлов в директории размещения скрипта)
- Для приведенных примеров логов нужно убрать заглушку в скрипте (#Заглушка для проверки на старых логах). Для проверки на "боевых" логах заглушку нужно убрать.

Пример:
- Пример вывода работы скрипта можно увидеть в приложенном файле output

# OtusLinux_Homework_4.
Что сделано:
- Осуществлен вход в систему без пароля несколькими способами:
    - Первый способ:
        Останавливаем загрузчик, в менюшке нажимаем 'e' для редактирования загрузчика
        Добавляем в параметры запуска ядра (строчка linux16) команду rd.break enforcing=0, нажимаем ctrl+x для перезагрузки
        Меняем пароль от root:

        mount -o remount,rw /sysroot
        chroot /sysroot
        passwd
        touch /.autorelabel
        mount -o remount,ro /
        exit
        exit

    - Второй способ:
        Останавливаем загрузчик, в менюшке нажимаем 'e' для редактирования загрузчика
        Добавляем в параметры запуска ядра (строчка linux16) команду init=/sysroot/bin/sh (подменив init процесс), нажимаем ctrl+x для перезагрузки
        Меняем пароль от root

        mount -o remount,rw /
        passwd
        touch /.autorelabel
        mount -o remount,ro /
        reboot
- Переименован VG. Лог работ приложен в work_part1.log, пруф на положительный результат в начале work_part2.log
- Добавлен модуль в initrd.  Лог работ приложен в work_part2.log. Скрипты заброшены с хост-машины в виртуальную командами:
    vagrant scp ./module-setup.sh otuslinux:/home/vagrant
    vagrant scp ./test.sh otuslinux:/home/vagrant


# OtusLinux_Homework_3.
Что сделано:
- Уменьшен том под / до 8G
- Выделен отдельный том под /home
- Выделен отдельный том под /var, том сделан в mirror
- /home сделан с условием снятия снапшотов. Работа проверена на примере восстановления со снапшота после удаления части файлов, заранее сгенерированных, перед снятием снапшота.
- Прописано монтирование в fstab.


# OtusLinux_Homework_2.
Что сделано:
- С помощью Vagrant поднята виртуальная машина c 6 дисками (дополнен конфигурационный файл)
- Собран RAID10, в mdadm.conf прописан его конфиг для загрузки при старте системы (теоретически этого можно не делать, информация о рейде записывается в образ начальной загрузки, однако, наличие файла mdadm.conf делает загрузку предсказуемой) 
- Создан GPT раздел и 5 партиций
- Выполнено задание со *. В конфиг Vagrant дописаны: доустановка пакета e2fsprogs.x86_64 (для создания партиций ext4), команды создания raid10, прописывания конфига рейда в mdadm, создания раздела и партиций, их форматирования и монтирования.


# OtusLinux_Homework_1.
Что сделано:
- С помощью Vagrant поднята виртуальная машина 
- На виртуальную машину с сайта https://www.kernel.org/ скачано ядро linux-3.16.61
- Собрали ядро. Согласно условиям ДЗ вытянут файл результирующей конфигурации и список модулей