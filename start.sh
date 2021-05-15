#!/bin/bash

folder_path=$HOME

show_menu () {
    # Si se selecciona cancelar devuelve 1 la funcion
    action=$(kdialog --title "PostgreSQL Server" --radiolist "Seleccione una operacion" \
        2 "Iniciar servidor" on \
        3 "Detener servidor" off)
    return $action
}

show_pid () {
    IFS=' '
    read -a pids <<< $(pidof "postgres")
    lenght=${#pids[*]}
    if [ $lenght -eq 0 ]; then
        kdialog --msgbox "Servidor detenido"
        return
    fi
    pid=${pids[$lenght-1]}
    kdialog --msgbox "Servidor iniciado: PID: $pid"
}

cd $folder_path
show_menu
action=$?

if [ $action -gt 1 ]
    then
        if [ $action -eq 2 ]
            then
                docker-compose up -d
                kdialog --title "Aviso" --passivepopup "Servidor iniciado" 5
            else
                docker-compose stop
                kdialog --title "Aviso" --passivepopup "Servidor detenido" 5
        fi
fi
    
exit 0
