#!/usr/bin/env bash

get_next_condition() {
    [[ $1 == "is_m" ]] && echo is_u && return
    [[ $1 == "is_u" ]] && echo is_l && return
    [[ $1 == "is_l" ]] && echo is_opar && return
    [[ $1 == "is_opar" ]] && echo is_num_or_comma && return
    [[ $1 == "is_num_or_comma" ]] && echo is_num_or_cpar && return
    [[ $1 == "is_num_or_cpar" ]] && echo done && return
}

is_num() {
    for i in 1 2 3 4 5 6 7 8 9 0;
    do
        [[ $1 == *$i* ]] && echo 1 && return
    done
    echo 0
}

is_opar() {
    [[ $1 == "(" ]] && echo 2 && return
    echo 0
}

is_m() {
    [[ $1 == "m" ]] && echo 2 && return
    echo 0
}

is_u() {
    [[ $1 == "u" ]] && echo 2 && return
    echo 0
}

is_l() {
    [[ $1 == "l" ]] && echo 2 && return
    echo 0
}

is_num_or_comma() {
    [[ `is_num "$1"` -eq 1 ]] && echo 1 && return
    [[ $1 == "," ]] && echo 2 && return
    echo 0
}

is_num_or_cpar() {
    [[ `is_num "$1"` -eq 1 ]] && echo 1 && return
    [[ $1 == ")" ]] && echo 3 && return
    echo 0
}

reset () {
    condition=is_m
    num1=""
    num2=""
}

total=0

while read line;
do
    reset
    for (( i=0; i<${#line}; i++ ));
    do
        char="${line:i:1}"

        # Character is some globbing pattern or something weird 
        # I don't really care
        [[ ${#char} -gt 1 ]] && reset && continue
        res=`$condition "${char}"`
        [[ $res -eq 0 ]] && reset && continue
        
        # We're getting a number
        if [[ $res -eq 1 ]]
        then
            [[ $condition == "is_num_or_comma" ]] && num1="$num1$char"
            [[ $condition == "is_num_or_cpar" ]] && num2="$num2$char"
        fi;
        # Just advance to the next condition
        [[ $res -eq 2 ]] && condition=`get_next_condition $condition` && continue

        # We successfully finished a valid string
        if [[ $res -eq 3 ]]
        then
            total=$(( total + num1 * num2 ))
            reset
        fi;
    done
done < input
echo $total
