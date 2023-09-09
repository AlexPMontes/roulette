#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Exiting...${endColour}\n"
  tput cnorm
  exit 1
}

# CTRL + C
trap ctrl_c INT

# Global variables

techniques_list="\n${blueColour}martingala\n${yellowColour}"

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Usage: "$0 -m [money] -t [technique]"${endColour}"
  echo -e "\t${purpleColour}h)${endColour} ${grayColour}Deploy this help panel${endColour}"
  echo -e "\t${purpleColour}m)${endColour} ${grayColour}Choose your initial amount of money${endColour}"
  echo -e "\t${purpleColour}t)${endColour} ${grayColour}Choose the technique you want to proove${endColour}"
  echo -e "\t${purpleColour}v)${endColour} ${grayColour}Verbose${endColour}"
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Actual money: ${blueColour}$money€"
  echo -ne "\n${yellowColour}[+]${endColour} ${grayColour}What's your initial bet? -> " && read initial_bet
  echo -ne "\n${yellowColour}[+]${endColour} ${grayColour}What do you want to bet on (even/odd)? -> " && read even_odd
  echo -ne "\n${yellowColour}[+]${endColour} ${grayColour}How much benefits do you want? -> " && read objective

  if [ $initial_bet -gt $money ] || ([ $even_odd != "even" ] && [ $even_odd != "odd" ]); then
    echo -e "\n${redColour}[!] ERROR -- Try to introduce correct parameters${endColour}"
    exit 1
  fi
  
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}You are going to play whith an initial bet of ${blueColour}$initial_bet ${grayColour}on ${blueColour}"$even_odd"${endColour}"

  tput civis
  
  initial_money=$money
  bet_num=0
  losing_streak=0
  actual_bet=$initial_bet 
  echo -e "${yellowColour}\n[+]You start with $money€${endColour}"
  
  while true; do
    if [ $money -lt $initial_bet ]; then
      echo -e "\n${redColour}[!] You lost all your money in $bet_num bets with a losing streak of $losing_streak bets :( ..."
      break

    elif [ $money -lt $actual_bet ]; then
      actual_bet=$initial_bet

    elif [ $money -ge $(($initial_money + $objective)) ]; then
      echo -e "\n${greenColour}[+] Congrats!! You won $objective€ in $bet_num bets :)"
      break
    
    else
      let bet_num+=1
      let money-=$actual_bet
      number=$(($RANDOM % 37))

      if [ $verbose -eq 1 ]; then echo -e "\nYou just bet $actual_bet€ and you have $money€"; fi
      
      if [ $number -eq 0 ] || ([ $(($number%2)) -eq 0 ] && [ $even_odd == "odd" ]) || ([ $(($number%2)) -eq 1 ] && [ $even_odd == "even" ]); then
        let actual_bet*=2
        
        let losing_streak+=1

        if [ $verbose -eq 1 ]; then echo -e "\n\t${redColour}[!]The roulette says $number -- Lost${endColour}"; fi      
      
      else
        
        let money+=$(($actual_bet*2))
        actual_bet=$initial_bet
        losing_streak=0
        
        if [ $verbose -eq 1 ]; then echo -e "\n\t${greenColour}[!]The roulette says $number -- Won${endColour}"; fi
        
      fi

      if [ $verbose -eq 1 ]; then echo -e "\n${yellowColour}[+]You have $money€${endColour}"; fi
    
    fi
  done
  tput cnorm
}


declare -i help_variable=0 
declare -i verbose=0

while getopts "m:t:hv" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) let help_variable+=1;helpPanel;;
    v) let verbose+=1;;
  esac
done



if [ $money ] && [ $technique ]; then

  if [ "$technique" == "martingala" ]; then
    martingala
  else
    echo -e "${redColour}\n[!] ERROR -- The introduced technique does not exist${endColour}\n\nHere you have the existent techniques: $techniques_list"
    exit 1
  fi

elif [ $help_variable -eq 0 ]; then
  echo -e "${redColour}\n[!] ERROR -- You have to introduce your initial amount of money and the technique you want to proove\nFor more help try \"$0 -h\"${endColour}\n"
  exit 1
fi
