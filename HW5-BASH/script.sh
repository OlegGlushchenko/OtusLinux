#!/bin/bash


P1=$1
P2=$2

## Пути до access.log, error.log. Заглушка
access=access-4560-c8671a.log
error=error-4560-d75c02.log


function printMan() {
    cat <<EOF
    $Script_Name [-help] [X] [Y]
    Скрипт присылает на заданную почту

    - X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
    
    - Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
    
    - все ошибки c момента последнего запуска
    
    - список всех кодов возврата с указанием их кол-ва с момента последнего запускаСкрипт ищет лог-файлы анализирует их на ошибки и отправляет отчет в виде html странички на почту.
    
    Параметры:
    -help
        Вывод справки
    [X]
    	Количество IP адресов с наибольшим количеством запросов
    [Y]
    	Количество адресов сайта с наибольшим количеством запросов
EOF
}
if [ "$P1" = "-help" ]; then
            printMan;
            exit
fi

# Включаем защиту от мультизапуска
LOCK=/tmp/monitoring.lock
if [ -f $LOCK ];then
	echo "Script is already running"
	exit 6
fi
touch $LOCK
trap 'rm -f "$LOCK"; exit $' INT TERM EXIT


# Проверка на наличие файла и установка последнего запуска
if [ "$(find . -name "output_*" -exec echo -n "1" \; )"  = "" ]
then

    ll_d=`date -d '1 hour ago' "+%Y-%m-%d"`
    ll_t=`date -d '1 hour ago' "+%H:%M:%S"`
    echo FILE CREATED

else
    #Работа с датой последнего запуска скрипта . lastlaunch
    # Формат 2018-11-12 
    ll_d=`ls -alt --full-time output* | head -n 1 | awk '{print $6}'`
    
    #Формат 17:56:19
    ll_t=`ls -alt --full-time output* | head -n 1 | awk '{print $7}' | cut -f1 -d"."`
fi

# Замена месяца. Форматирование в вид 08/Nov/2018:17:09:50 для логов access
ll_ac="`echo $ll_d | awk -F "-" '{print $3,$2,$1}' | sed 's/ /-/g' | {
sed -e '
s/-01-/\/Jan\//
s/-02-/\/Feb\//
s/-03-/\/Mar\//
s/-04-/\/Apr\//
s/-05-/\/May\//
s/-06-/\/Jun\//
s/-07-/\/Jul\//
s/-08-/\/Aug\//
s/-09-/\/Sep\//
s/-10-/\/Oct\//
s/-11-/\/Nov\//
s/-12-/\/Dec\//'
}`:$ll_t"

# Форматирование в вид 2018/11/08:17:09:50 для логов error
ll_er="`echo $ll_d | sed 's/-/\//g'`:$ll_t"

# Создаем файл output.log
dt=`date '+%d-%m-%Y_%H-%M-%S'`
OUTPUT=output_$dt.log
touch $OUTPUT
echo "Лог с момента $ll_d $ll_t" >> $OUTPUT

#Заглушка для проверки на старых логах
#ll_ac="08/Nov/2018:17:09:50"
#ll_er="2018/11/08:17:09:50"


# X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта 	
echo "IP адреса с наибольшим количетвом запросов c момента последнего запуска скрипта:" >> $OUTPUT

declare -A addresses

# Построчно из логов выдираем столбцы с IP и датой-временем, проверяем дату-время. По выполнению условия считаем количество IP 
for line in $(awk '{print $1 $4}' "$access"); do
    ll_ds="`echo $line | grep -oP '\d{1,2}\/\w{1,3}\/\d{1,4}\:\d{1,2}\:\d{1,2}\:\d{1,2}'`"
    address=$(echo $line | grep -oP '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')
    if [ "$ll_ac" \< "$ll_ds" ]
    then
        if [[ ${addresses["$address"]+_} ]]; then
            ((++addresses["$address"]))
        else
            addresses["$address"]=1
        fi
    fi 
done

# Создаем временный файл, в который записывем наш набор IP, после чего сортируем и "отрезаем" только X адресов, дописываем в файл вывода
TMP_RESULT=$(mktemp)
for address in "${!addresses[@]}"; do
    echo ${address}: ${addresses["$address"]} >> "$TMP_RESULT"
done

sort -rnk 2 "$TMP_RESULT" | sed -ne "1,${P1}p" >> $OUTPUT

rm "$TMP_RESULT"


# Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта\
echo " " >> $OUTPUT
echo "Запрашиваемые адреса с наибольшим количеством запросов c момента последнего запуска скрипта:" >> $OUTPUT

declare -A requests
# Построчно из логов выдираем столбцы с адресами и датой-временем, проверяем дату-время. По выполнению условия счетаем кол-во адресов 
for line in $(awk '{print $7 $4}' "$access"); do
    ll_ds="`echo $line | grep -oP '\d{1,2}\/\w{1,3}\/\d{1,4}\:\d{1,2}\:\d{1,2}\:\d{1,2}'`"
    request=${line%[*}
    if [ "$ll_ac" \< "$ll_ds" ]
    then
        if [[ ${requests["$request"]+_} ]]; then
            ((++requests["$request"]))
        else
            requests["$request"]=1
        fi
    fi 
done

# Создаем временный файл, в который записывем наш набор адресов (адрес - количетво) , после чего сортируем и "отрезаем" только Y адресов, записываем в файл вывода
TMP_RESULT=$(mktemp)
for request in "${!requests[@]}"; do
    echo ${request}: ${requests["$request"]} >> "$TMP_RESULT"
done

sort -rnk 2 "$TMP_RESULT" | sed -ne "1,${P2}p" >> $OUTPUT
rm "$TMP_RESULT"

# все ошибки c момента последнего запуска
echo " " >> $OUTPUT
echo "Все ошибки c момента последнего запуска:" >> $OUTPUT

# Построчно читаем лог ошибок, формируем дата-время нужного формата, проверяем условие времени, при выполнении условия дописываем в файл вывода
while read line; do
    ll_ds="`echo $line | grep -oP '\d{1,4}\/\d{1,2}\/\d{1,2}'`"
    ll_ds+=":`echo $line | grep -oP '\d{1,2}\:\d{1,2}\:\d{1,2}'`"
    if [ "$ll_er" \< "$ll_ds" ]
        then
        echo  ${line#*\*} >> $OUTPUT
    fi
done < $error


# Список всех кодов возврата с момента последнего запуска

echo " " >> $OUTPUT
echo "Cписок всех кодов возврата с указанием их кол-ва с момента последнего запуска:" >> $OUTPUT

declare -A codes 

# Построчно "выдираем" из файла логов доступа поля даты-времени и кодов возврата (для простоты отделяем их '|'')
for line in $(awk '{print $4 "|" $9}' "$access"); do
    ll_ds="`echo $line | grep -oP '\d{1,2}\/\w{1,3}\/\d{1,4}\:\d{1,2}\:\d{1,2}\:\d{1,2}'`"
    code=${line#*|*}
    if [ "$ll_ac" \< "$ll_ds" ]
    then
        if [[ ${codes["$code"]+_} ]]; then
            ((++codes["$code"]))
        else
            codes["$code"]=1
        fi
    fi 
done

# Создаем временный файл, в который записывем наш набор кодов возврата, после чего сортируем и дописываем в файл вывода
TMP_RESULT=$(mktemp)
for code in "${!codes[@]}"; do
    echo ${code}: ${codes["$code"]} >> "$TMP_RESULT"
done

sort -rnk 2 "$TMP_RESULT" >> $OUTPUT
rm "$TMP_RESULT"


#cat $OUTPUT
mail -s "Stat from nginx server $dt" olegluschenko@gmail.com < $OUTPUT

# Снимаем защиту (трап)
rm -f $LOCK
trap - INT TERM EXIT