#!/usr/bin/env bash

safe_reports=0
while read line;
do
    lastval=none
    lastdiff=none
    diff=none
    is_safe=1
    echo "New line"
    for value in $line;
    do
        [[ $lastval == none ]] && lastval=$value && continue
        diff=$(( lastval - value ))
        echo $value $lastval $diff $lastdiff
        [[ $diff -eq 0 ]] && is_safe=0 && break
        ( [[ $diff -lt -3 ]] || [[ $diff -gt 3 ]] ) && is_safe=0 && break
        [[ $lastdiff == none ]] && lastdiff=$diff && lastval=$value && continue
        [[ $(( diff*100/lastdiff )) -lt 0 ]] && is_safe=0 && break
        lastval=$value
        lastdiff=$diff
    done;
    echo safe $is_safe
    safe_reports=$(( safe_reports + is_safe ))
done < input
echo $safe_reports
