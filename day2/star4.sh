#!/usr/bin/env bash

safe_reports=0
counter=0
while read line;
do
    counter=$(( counter+1 ))
    echo "line $counter"
    i=0
    for _ in $line;
    do
        is_safe=1
        j=0
        echo "removing value $i"
        lastval=none
        lastdiff=none
        diff=none
        for value in $line;
        do
            [[ $i == $j ]] && j=$(( j + 1 )) && continue
            echo $value $i $j
            [[ $lastval == none ]] && j=$(( j + 1 )) && lastval=$value && continue
            diff=$(( lastval - value ))
            [[ $diff -eq 0 ]] && is_safe=0 && break
            ( [[ $diff -lt -3 ]] || [[ $diff -gt 3 ]] ) && is_safe=0 && break
            [[ $lastdiff == none ]] && lastdiff=$diff && j=$(( j + 1 )) && lastval=$value && continue
            [[ $(( diff*100/lastdiff )) -lt 0 ]] && is_safe=0 && break
            lastval=$value
            lastdiff=$diff
            j=$(( j + 1 ))
        done;
        [[ $is_safe -eq 1 ]] && break
        i=$(( i + 1 ))
    done;
    echo safe $is_safe
    safe_reports=$(( safe_reports + is_safe ))
done < input
echo $safe_reports
