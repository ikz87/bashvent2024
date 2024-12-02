#!/usr/bin/env bash

LEFT=()
RIGHT=()

counter=0
while read line;
do
    echo $counter
    left_value=`echo "${line%% *}"`
    right_value=`echo "${line##* }"`
    LEFT+=($left_value)
    RIGHT+=($right_value)

    # I wanted to have some fun ok?
    eval "[[ -z \$total_left_`echo $left_value` ]] && total_left`echo $left_value`=0"
    eval "total_left_`echo $left_value`=\$(( total_left_`echo $left_value` + 1 ))"

    eval "[[ -z \$total_right_`echo $right_value` ]] && total_right`echo $right_value`=0"
    eval "total_right_`echo $right_value`=\$(( total_right_`echo $right_value` + 1 ))"

    counter=$(( counter + 1 ))
done < input

lines=`wc -l input`
lines=`echo "${lines%% *}"`
total=0

for (( i = 0; i < $lines; i++ )); do
    left_value=${LEFT[$i]}
    eval "total=\$(( total + left_value * total_right_`echo $left_value` * total_left_`echo $left_value` ))"
    eval "total_left_`echo $left_value`=0"
    eval "total_right_`echo $left_value`=0"
    echo $i
done

echo $total
