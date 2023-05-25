#!/bin/bash

# crio um arquivo para adicionar as minhas tarefas
TODO_FILE=~/todo.txt

if [ ! -f $TODO_FILE ]; then
    touch $TODO_FILE
fi

show_help() {
    cat << EOF
Uso: todo [comando] [texto]
Comandos:
  add [texto]  Adiciona uma nova tarefa
  list         Lista todas as tarefas
  remove [n]   Remove a tarefa n
EOF
}

add_todo() {
    echo $1 >>$TODO_FILE
}

list_todos() {
    if [ ! -s $TODO_FILE ]; then
        echo "Nenhuma tarefa encontrada"
        return
    fi

    local i=1
    while read line; do
        echo "$i: $line"
        i=$((i + 1))
    done <$TODO_FILE
}

remove_todo() {
    local i=1
    local temp_file=$(mktemp)

    while read line; do
        if [ $i -ne $1 ]; then
            echo $line >>$temp_file
        fi
        i=$((i + 1))
    done <$TODO_FILE

    mv $temp_file $TODO_FILE
}

if [ $# -eq 0 ]; then
    show_help
else
    case $1 in
    add)
        shift
        add_todo "$*"
        ;;
    list)
        list_todos
        ;;
    remove)
        shift
        remove_todo $1
        ;;
    *)
        show_help
        ;;
    esac
fi
