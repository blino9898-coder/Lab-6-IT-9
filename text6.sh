#!/bin/bash

# Инициализация доски как массива 3x3
declare -A board
for i in {1..3}; do
    for j in {1..3}; do
        board[$i,$j]=" "
    done
done

# Функция для вывода доски
print_board() {
    echo -e "\n"
    for i in {1..3}; do
        echo " ${board[$i,1]} | ${board[$i,2]} | ${board[$i,3]} "
        if [ $i -lt 3 ]; then
            echo "-----------"
        fi
    done
    echo -e "\n"
}

# Функция для проверки победителя
check_winner() {
    local player=$1

    # Проверка строк и столбцов
    for i in {1..3}; do
        if [[ ${board[$i,1]} == $player && ${board[$i,2]} == $player && ${board[$i,3]} == $player ]]; then
            return 0
        fi
        if [[ ${board[1,$i]} == $player && ${board[2,$i]} == $player && ${board[3,$i]} == $player ]]; then
            return 0
        fi
    done

    # Проверка диагоналей
    if [[ ${board[1,1]} == $player && ${board[2,2]} == $player && ${board[3,3]} == $player ]]; then
        return 0
    fi
    if [[ ${board[1,3]} == $player && ${board[2,2]} == $player && ${board[3,1]} == $player ]]; then
        return 0
    fi

    return 1
}

# Функция для проверки, заполнена ли доска
is_board_full() {
    for i in {1..3}; do
        for j in {1..3}; do
            if [[ ${board[$i,$j]} == " " ]]; then
                return 1 # Доска не заполнена
            fi
        done
    done
    return 0 # Доска заполнена
}

# Основной игровой цикл
main() {
    local current_player="X"

    echo "Крестики-Нолики!"
    echo "Игроки ходят по очереди. Введите номер строки и столбца от 1 до 3."

    while true; do
        print_board

        # Получить ввод для строки
        while true; do
            read -p "Игрок $current_player, введите строку (1-3): " row
            if [[ $row =~ ^[1-3]$ ]]; then
                break
            else
                echo "Пожалуйста, введите целое число от 1 до 3."
            fi
        done

        # Получить ввод для столбца
        while true; do
            read -p "Игрок $current_player, введите столбец (1-3): " col
            if [[ $col =~ ^[1-3]$ ]]; then
                break
            else
                echo "Пожалуйста, введите целое число от 1 до 3."
            fi
        done

        # Проверить, пуста ли ячейка
        if [[ ${board[$row,$col]} != " " ]]; then
            echo "Эта ячейка уже занята. Выберите другую."
            continue
        fi

        # Обновить доску
        board[$row,$col]=$current_player

        # Проверить победителя
        if check_winner "$current_player"; then
            print_board
            echo "Игрок $current_player победил!"
            break
        fi

        # Проверить на ничью
        if is_board_full; then
            print_board
            echo "Ничья!"
            break
        fi

        # Сменить игрока
        current_player=$([ "$current_player" == "X" ] && echo "O" || echo "X")
    done
}

# Начать игру
main
