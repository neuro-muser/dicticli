#!/bin/bash

WORDLIST="$(dirname $0)/words.txt"
TRANSLATE_ATTEMPTS=3
LOCK_SECONDS=900

echo_deluxe(){
	local color_code=$1
    local text=$2
    echo -e "\e[${color_code}m${text}\e[0m"
}

handle_signals() {
	echo ""
}

wrong_answer(){
	echo_deluxe $RED "Wrong! Correct translation: '$english'\n"
	sleep 3
	clear
	main
}

locking_dictionary(){
	local lock="$(dirname $0)/.lock.lck"
	touch $lock
	sleep $LOCK_SECONDS 
	rm $lock
}

right_answer(){
	echo_deluxe $GREEN "Correct!"
	num=$((num+1))
	strnum="$(grep -n -F -w "$english" $WORDLIST | cut -d : -f 1)s"
	# sed -i "${strnum}s/.*/$english\t|\t$ukrainian\t|\t$num/" "$WORDLIST"
	perl -pe "s/^\Q$english\E.*/$english\t|\t$ukrainian\t|\t$num/" "$WORDLIST" > temp && mv temp "$WORDLIST"

	locking_dictionary & ## create lock so dictionary wouldn`t appear next 15 mins
	
	[ "$num" -ge $TRANSLATE_ATTEMPTS ] && sed -i "/$english/d" $WORDLIST && echo_deluxe $YELLOW "Word deleted!"
	exit 0
}

main(){
	trap handle_signals INT QUIT TERM HUP
	line=$(shuf -n 1 "$WORDLIST")

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

[ -f "$(dirname $0)/.lock.lck" ] || main
