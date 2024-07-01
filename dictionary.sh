#!/bin/bash

words="$(dirname $0)/words.txt"

handle_signals() {
    echo_deluxe $RED "Niemals, du schlaues Schwein!"
}


echo_deluxe(){
	local color_code=$1
    local text=$2
    echo -e "\e[${color_code}m${text}\e[0m"
}

wrong_answer(){
	echo_deluxe $RED "Wrong! Correct translation: '$english'\n"
	main
}


right_answer(){
	echo_deluxe $GREEN "Correct!"
	num=$((num+1))
	strnum="$(grep -n -F -w "$english" $words | cut -d : -f 1)s"
	# sed -i "${strnum}s/.*/$english\t|\t$ukrainian\t|\t$num/" "$words"
	perl -pe "s/^\Q$english\E.*/$english\t|\t$ukrainian\t|\t$num/" "$words" > temp && mv temp "$words"
	[ "$num" -ge 3 ] && sed -i "/$english/d" $words && echo_deluxe $YELLOW "ГООООООЛ"
	exit 0
}

main(){
	trap handle_signals INT QUIT TERM HUP
	line=$(shuf -n 1 "$words")

	english=$(echo "$line" | awk -F '|' '{print $1}' | xargs)
	ukrainian=$(echo "$line" | awk -F '|' '{print $2}' | xargs)
	num=$(echo "$line" | awk -F '|' '{print $3}' | xargs)

	echo_deluxe $YELLOW "Translate: '$ukrainian'"
	read -p ">>>" user_input
	[[ "${user_input,,}" == "${english,,}" ]] && right_answer || wrong_answer
}

RED="31"
GREEN="32"
YELLOW="33"

main
