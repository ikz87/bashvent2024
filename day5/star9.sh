#!/usr/bin/env bash

# I split the puzzle input into 2 files
# cuz honestly that seems fair
rules="rules"
input="input"


total=0

counter=1

while read line;
do
    line=`echo $line | sed "s/,/ /g"`
    ordered=1
    for num in $line;
    do
        # Apply rules that have to do with num
        while read rule;
        do
            right=`echo "${rule##*|}"`

            # If the line doesn't contain both numbers, move on
            echo $line | grep -v $right > /dev/null && continue

            # Check whether $right is 
            # at the right of $num in the line
            for num_comp in $line;
            do
                # If we find $right first
                # line isn't ordered
                [[ $num_comp == $right ]] && ordered=0 && break
                # If we find $num first
                # line is ordered thus far
                [[ $num_comp == $num ]] && continue 2
            done
        done < <(grep $num\| $rules)
    done
    
    echo "Line $counter ordering is: $ordered"
    if [[ $ordered == 1 ]];
    then
        total_words=`echo $line | wc -w`
        center_word_index=$(( (total_words / 2) * 3 ))
        num_to_add=${line:center_word_index:2}
        total=$(( total + num_to_add * ordered ))
        counter=$(( counter + 1 ))
    fi
done < $input
echo "Total is $total"
