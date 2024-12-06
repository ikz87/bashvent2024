#!/usr/bin/env bash

input="input"

height=$(wc -l $input)
height=`echo "${height%% *}"`
total_chars=$(wc -m $input)
total_chars=`echo "${total_chars%% *}"`
width=$(( total_chars / height ))

# File wasn't used to solve the puzzle
# I just wanted to have a cool visualization
# without modifying the original input
cp $input visualization

replace_char() {
    local file=visualization
    local x=$1
    local y=$2
    local new_char=$3

    awk -v x="$x" -v y="$y" -v new_char="$new_char" '
    {
        if (NR == y + 1) {
            $0 = substr($0, 1, x) new_char substr($0, x + 2)
        }
        print
    }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}


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

curr_x="91"
curr_y="53"
positions=". $curr_x,$curr_y"
total_positions=1
view_x=0
view_y=-1

while true;
do
    viewing_x=$(( curr_x + view_x ))
    viewing_y=$(( curr_y + view_y ))
    next_char=`get_char_from_xy $viewing_x $viewing_y`
    echo "Curr position is $curr_x $curr_y"

    # If next_char is a #, rotate to the right
    if [[ $next_char == "#" ]];
    then
        if [[ $view_x -eq 0 ]];
        then
            view_x=$(( -1 * view_y ))
            view_y=0
        else
            view_y=$view_x
            view_x=0
        fi;
        viewing_x=$(( curr_x + view_x ))
        viewing_y=$(( curr_y + view_y ))
    fi;

    # The guard will exit the frame
    [[ -z "$next_char" ]] && break

    # Save position if it's not already in $positions
    if [[ `echo $positions | grep -c ". $curr_x,$curr_y ."` -eq 0 ]];
    then
        replace_char $curr_x $curr_y "X"
        positions="$positions $curr_x,$curr_y ."
        total_positions=$(( total_positions + 1 ))
    fi

    curr_x=$(( curr_x + view_x ))
    curr_y=$(( curr_y + view_y ))
done

echo $total_positions
