#!/usr/bin/env bash

input="input"
word="XMAS"

height=$(wc -l $input)
height=`echo "${height%% *}"`
total_chars=$(wc -m $input)
total_chars=`echo "${total_chars%% *}"`
width=$(( total_chars / height ))

get_char_from_xy () {
    local x=$1
    local y=$2
    [[ $x -ge $width ]] && echo "" && return
    [[ $y -ge $height ]] && echo "" && return
    [[ $x -lt 0 ]] && echo "" && return
    [[ $y -lt 0 ]] && echo "" && return
    line_at_y=`head -$(( y + 1)) $input | tail -n 1` 
    char_at_xy="${line_at_y:$(( x )):1}"
    echo "$char_at_xy"
}

get_next_letter () {
    local current_letter=$1
    for (( i=0; i<${#word}; i++ ));
    do
        if [[ ${word:$i:1} == $current_letter ]];
        then
            echo ${word:$((i + 1)):1}
        fi
    done
}

total=0
total_chars=$(( width * height ))
char_to_find=M
for (( y=0; y<height; y++));
do
    for (( x=0; x<width; x++));
    do
        char=`get_char_from_xy $x $y`
        echo "Analizing char $x $y $char $total"
        if [[ $char == X ]];
        then
            for (( offset_y=-1; offset_y<=1; offset_y++ ));
            do
                for (( offset_x=-1; offset_x<=1; offset_x++ ));
                do
                    # do nothing if offsets are 0
                    [[ $offset_y -eq 0 ]] && [[ $offset_x -eq 0 ]] && continue
                    i=1
                    while true;
                    do
                        offseted_x=$(( offset_x * i + x))
                        offseted_y=$(( offset_y * i + y))
                        next_char_in_direction=`get_char_from_xy $offseted_x $offseted_y`
                        echo "Trying with offset, now at $offseted_x $offseted_y. Searching for $char_to_find, got $next_char_in_direction"
                        # We reached the edge of the file and 
                        # didn't complete the word. Just break
                        [[ $next_char_in_direction = "" ]] && char_to_find=M && break

                        # Wrong char
                        [[ $next_char_in_direction != $char_to_find ]] && char_to_find=M && break
                        if [[ $next_char_in_direction == $char_to_find ]];
                        then
                            # We finished a word. Update total and break
                            if [[ $char_to_find == "S" ]];
                            then
                                echo "Found word"
                                char_to_find=M
                                total=$(( total + 1 ))
                                break
                            fi
                            char_to_find=`get_next_letter $char_to_find`
                        fi;
                        i=$(( i + 1 ))
                    done
                done
            done
        fi
    done
done < $input
echo $total
