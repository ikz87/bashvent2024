#!/usr/bin/env bash

# I split the puzzle input into 2 files
# cuz honestly that seems fair
rules="rules"
input="input"


total=0

counter=1

while read line;
do
    ordered=1
    line=`echo $line | sed "s/,/ /g"`
    for num in $line;
    do
        # Apply rules that have to do with num
        while read rule;
        do
            right=`echo "${rule##*|}"`

            # If the line doesn't contain both numbers, move on
            echo $line | grep -v $right > /dev/null && continue

            # Check whether $right is already
            # at the right of $num in the line
            for num_comp in $line;
            do
                # If we find $right first
                # rule gets applied
                [[ $num_comp == $right ]] && break
                # If we find $num first
                # rule gets skipped
                [[ $num_comp == $num ]] && continue 2
            done

            ordered=0
            echo "Applying rule $rule in line $counter"
            # Some sed trickery
            line=`echo $line | sed "s/$num//g"`
            line=`echo $line | sed "s/$right/$num $right/g"`
            line=`echo $line | sed "s/  / /g"`

        done < <(grep $num\| $rules)
    done
    if [[ $ordered -eq 0 ]];
    then
        total_words=`echo $line | wc -w`
        center_word_index=$(( (total_words / 2) * 3 ))
        num_to_add=${line:center_word_index:2}
        total=$(( total + num_to_add ))
    else
        echo "Line $counter was already ordered"
    fi;
    counter=$(( counter + 1 ))
done < $input
echo "Total is $total"
