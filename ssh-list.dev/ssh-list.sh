#!/bin/bash

#ssh-list
#parses available hostnamenames from user's home directory ~/.ssh/config file

sshf='.ssh'
conf='config'
srcp=$HOME
fpth="$HOME/$sshf/$conf"

#cat "$fpth" && exit 0


cat "$fpth" | while read -r line; do

field=$(echo "$line" | awk '{ print $1 }')
value=$(echo "$line" | awk '{ print $2 }')

if [ "$field" ] && [ "$value" ]; then
   #Print out and format the parsed data here:
   
   case $field in
      'Hostname')
         hostname="$value"
         newentry=1
         ;;
      User)
         user="$value"
         newentry=1
         ;;
      'Host')
         newentry=0
         if [ $host ] 2>/dev/null
         then
           echo -e "\t$host:\n\t$user@$hostname\n"
         fi
         host="$value"
         ;;
      *)
         error=1
         newentry=1
         #echo -e "\t\t\t$line"
         ;;
    esac
fi
done
#final iteration which would have gotten 'lost'
#           echo -e "\t $host \t $user@$hostname"


exit 0
