#!/usr/bin/env bash

# Could've done this a bit more clever but it's really late already
# + didn't wanna use grep cuz that wouldn't be fun

get_next_dont_condition() {
    [[ $1 == "is_d" ]] && echo is_o && return
    [[ $1 == "is_o" ]] && echo is_n && return
    [[ $1 == "is_n" ]] && echo is_quote && return
    [[ $1 == "is_quote" ]] && echo is_t && return
    [[ $1 == "is_t" ]] && echo is_opar && return
    [[ $1 == "is_opar" ]] && echo is_cpar && return
    [[ $1 == "is_cpar" ]] && echo done && return
}

get_next_do_condition() {
    [[ $1 == "is_d" ]] && echo is_o && return
    [[ $1 == "is_o" ]] && echo is_opar && return
    [[ $1 == "is_opar" ]] && echo is_cpar && return
    [[ $1 == "is_cpar" ]] && echo done && return
}

get_next_mul_condition() {
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

is_cpar() {
    [[ $1 == ")" ]] && echo 3 && return
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

is_d() {
    [[ $1 == "d" ]] && echo 2 && return
    echo 0
}

is_o() {
    [[ $1 == "o" ]] && echo 2 && return
    echo 0
}

is_n() {
    [[ $1 == "n" ]] && echo 2 && return
    echo 0
}

is_quote() {
    [[ $1 == "'" ]] && echo 2 && return
    echo 0
}

is_t() {
    [[ $1 == "t" ]] && echo 2 && return
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

reset_mul () {
    mulcondition=is_m
    num1=""
    num2=""
}

total=0

active=1
while read line;
do
    reset_mul
    docondition="is_d"
    dontcondition="is_d"
    for (( i=0; i<${#line}; i++ ));
    do
        char="${line:i:1}"

        # Character is some globbing pattern or something weird 
        # I don't really care
        [[ ${#char} -gt 1 ]] && reset_mul && continue

        dores=`$docondition "${char}"`
        if [[ $dores -eq 0 ]];
        then
            docondition="is_d"
        
        # Just advance to the next condition
        elif [[ $dores -eq 2 ]];
        then
            docondition=`get_next_do_condition $docondition`

        # We successfully finished a valid string
        elif [[ $dores -eq 3 ]]
        then
            active=1
            docondition="is_d"
        fi;
        
        dontres=`$dontcondition "${char}"`
        if [[ $dontres -eq 0 ]];
        then
            dontcondition="is_d" 
        # Just advance to the next condition
        elif [[ $dontres -eq 2 ]];
        then
            dontcondition=`get_next_dont_condition $dontcondition`

        # We successfully finished a valid string
        elif [[ $dontres -eq 3 ]]
        then
            active=0
            dontcondition="is_d" 
        fi;

        mulres=`$mulcondition "${char}"`
        if [[ $mulres -eq 0 ]]
        then 
            reset_mul
        
        # We're getting a number
        elif [[ $mulres -eq 1 ]]
        then
            [[ $mulcondition == "is_num_or_comma" ]] && num1="$num1$char"
            [[ $mulcondition == "is_num_or_cpar" ]] && num2="$num2$char"
        # Just advance to the next condition
        elif [[ $mulres -eq 2 ]]
        then
            mulcondition=`get_next_mul_condition $mulcondition`

        # We successfully finished a valid string
        elif [[ $mulres -eq 3 ]]
        then
            total=$(( total + num1 * num2 * active ))
            reset_mul
        fi;
    done
done < input
echo $total
