# OtusLinux_Homework_2.
Что сделано:
- С помощью Vagrant поднята виртуальная машина c 6 дисками (дополнен конфигурационный файл)
- Собран RAID10, в mdadm.conf прописан его конфиг для загрузки при старте системы (теоретически этого можно не делать, информация о рейде записывается в образ начальной загрузки, однако, наличие файла mdadm.conf делает загрузку предсказуемой) 
- Создан GPT раздел и 5 партиций
- Выполнено задание со *. В конфиг Vagrant дописаны: доустановка пакета e2fsprogs.x86_64 (для создания партиций ext4), команды создания raid10, прописывания конфига рейда в mdadm, создания раздела и партиций, их форматирования и монтирования.

# OtusLinux_Homework_3.
Что сделано:
- Уменьшен том под / до 8G
- Выделен отдельный том под /home
- Выделен отдельный том под /var, том сделан в mirror
- /home сделан с условием снятия снапшотов. Работа проверена на примере восстановления со снапшота после удаления части файлов, заранее сгенерированных, перед снятием снапшота.
- Прописано монтирование в fstab.