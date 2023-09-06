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
}

function martingala(){
  echo -e "martingala"
}


declare -i help_variable=0 

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) let help_variable+=1;helpPanel;;
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
