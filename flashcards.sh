#!/bin/bash
#flashcards
#practice terms for the comptia network and security exams based on a user-created CSV file
#. ifexists figlet
csv_file=$HOME/local/bin/flashcards.d/flashcard_source_data.csv
recordNumber=()
user_entry=n
gcol() {
   requested_color=$1
   if [ ! $requested_color ]; then
      echo "Error.  No color name passed as an argument."
   fi
   case $requested_color in
      blue)
            echo -en '\033[36m'
            ;;
      red)
            echo -en '\033[31m'
            ;;
      white)
            echo -en '\033[00m'
            ;;
      yellow)
            echo -en '\033[33m'
            ;;
      green)
            echo -en '\033[32m'
            ;;
      navy)
            echo -en '\033[34m'
            ;;
      purple)
            echo -en '\033[35m'
            ;;
      *)
            echo -en '\033[00m'
            ;;
   esac
}
check_hash() {
   if [ ! "$1" ]; then
      echo "Please include a function or program to check"
   fi
   hash $1 2>/dev/null
   errck=$?
   if [ $errck -eq 0 ]; then
      #echo "$1 installed"
      query_installed=true
  else
      echo "$1 not installed.  Please install before continuting."
      read -p "Press (Y) to continue or (N) to exit: " yesno
      case $yesno in
            Y*|y*)
                  echo "You may experience bugs."
                  ;;
            *)
                  echo "Exiting..."
                  exit 0
                  ;;
      esac
  fi
}
#check_hash figlet
load_array() {
   count=0
   while read -r line; do
      ((count++))
      recordNumber[$count]=$line
   done <<<$(cat $csv_file)
}
gen_random() {
   number=0
   floor=2
   range=$(($(wc -l $csv_file | awk '{ print $1 }') - 1))
   while [ $number -le $floor ]; do
      number=$RANDOM
      let "number %= $range"
   done
   export random_entry=$number
   echo $random_entry
}
load_array
center_text() {
   COLUMNS=$(tput cols) 
   title="$*" 
   printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
}
prep_question() {
   current_question="$(echo ${recordNumber[$(gen_random)]})"
   clear
   question_number="$(echo $current_question | awk -F, '{ print $1 }')"
   echo
   gcol blue
   center_text "Technology term number $question_number"
   gcol yellow
   #figlet -c -f digital "$(echo $current_question | awk -F, '{ print $2 }')"
   center_text "$(echo $current_question | awk -F, '{ print $2 }')"
}
get_answer() {
   echo
   echo
   gcol blue
   read -p "$(center_text '(N)ext | (E)xit: ')" user_entry
   case $user_entry in
      n*|N*)
               echo
               gcol green
               center_text "The answer is..." 
               gcol white
               center_text "$(echo $current_question | awk -F, '{ print $3 }')"
               gcol red
               read -p "$(center_text 'Press <Enter> to continue')" anykey
               prep_question
               ;;
      e*|E*)
               echo "Exiting..."
               exit
               ;;
      *)
               exit
               ;;
   esac
}
while [ $user_entry == "s" ] || [ $user_entry == "S" ] || [ $user_entry == "n" ] || [ $user_entry == "N" ]; do
   prep_question
   get_answer
done
