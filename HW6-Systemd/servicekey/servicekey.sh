#!/bin/bash

if [[ ! "$FILE_PATH" ]]; then
    echo "Can't find path to file. Check /etc/sysconfig/servicekey" >&2
    exit 1
fi

if [[ ! "$KEY_WORD" ]]; then
    echo "Can't find key word. Check /etc/sysconfig/servicekey" >&2
fi

echo "Trying find ${KEY_WORD} in ${FILE_PATH}"

grep "$KEY_WORD" "$FILE_PATH"