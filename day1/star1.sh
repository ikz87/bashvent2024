#!/usr/bin/env bash

# Bruh this is so slow lmao
# not sure what the clever solution would be
# ig it'd start by using a better language

compare () {
   i=$1
   while [[ $i -gt 0 ]]; do
       before=$(( i - 1 ))
       if [[ ${LEFT[$i]} -gt ${LEFT[$before]} ]];
       then
           tmp=${LEFT[$i]}
           LEFT[$i]=${LEFT[$before]}
           LEFT[$before]=$tmp
       else
           break
        fi;
        i=$(( i - 1 ))
   done
   i=$1
   while [[ $i -gt 0 ]]; do
       before=$(( i - 1 ))
       if [[ ${RIGHT[$i]} -gt ${RIGHT[$before]} ]];
       then
           tmp=${RIGHT[$i]}
           RIGHT[$i]=${RIGHT[$before]}
           RIGHT[$before]=$tmp
       else
           break
        fi;
        i=$(( i - 1 ))
   done
}

export LEFT=()
export RIGHT=()

counter=0
while read line;
do
    echo $counter
    left_value=`echo "${line%% *}"`
    right_value=`echo "${line##* }"`
    LEFT+=($left_value)
    RIGHT+=($right_value)
    compare $counter
    counter=$(( counter + 1 ))
done < input

lines=`wc -l input`
lines=`echo "${lines%% *}"`
total=0

for (( i = 0; i < $lines; i++ )); do
    left_element=${LEFT[$i]}
    right_element=${RIGHT[$i]}
    diff=$(( left_element - right_element ))
    [[ $diff -lt 0 ]] && diff=$(( diff * -1 ))
    total=$(( total + diff ))
done

echo $total
