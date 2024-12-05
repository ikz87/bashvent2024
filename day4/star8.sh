#!/usr/bin/env bash

input="input"

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

        # Center of the X-MAS
        if [[ $char == A ]];
        then
            top_left=`get_char_from_xy $(( x - 1 )) $(( y - 1 ))`
            top_right=`get_char_from_xy $(( x + 1 )) $(( y - 1 ))`
            bottom_left=`get_char_from_xy $(( x - 1 )) $(( y + 1 ))`
            bottom_right=`get_char_from_xy $(( x + 1 )) $(( y + 1 ))`

            # Check if the X is formed
            [[ $top_left != M ]] && [[ $top_left != S ]] && continue
            [[ $top_right != M ]] && [[ $top_right != S ]] && continue
            [[ $bottom_left != M ]] && [[ $bottom_left != S ]] && continue
            [[ $bottom_right != M ]] && [[ $bottom_right != S ]] && continue

            cross=0
            if [[ $top_left == M ]] && [[ $bottom_right == S ]];
            then
                cross=$(( cross + 1 ))
            elif [[ $top_left == S ]] && [[ $bottom_right == M ]]
            then
                cross=$(( cross + 1 ))

            fi
            if [[ $top_right == M ]] && [[ $bottom_left == S ]];
            then
                cross=$(( cross + 1 ))
            elif [[ $top_right == S ]] && [[ $bottom_left == M ]]
            then
                cross=$(( cross + 1 ))
            fi

            if [[ $cross -eq 2 ]];
            then
                total=$(( total + 1 ))
                echo "Added to total at $x $y, now total is $total"
            fi
        fi
    done
done < $input
echo $total
