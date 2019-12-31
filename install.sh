#!/bin/bash

if [ ! -d ~/git ]; then
   echo "Error.  Expected to find folder /home/$USER/git.  Not found.  Exiting"
   exit
fi

read -p "WARNING! Press D|d to DELETE your existing /home/$USER/local/bin folder or M|m to MERGE or press E|e to EXIT: D|M|E: " overwrite_option
case $overwrite_option in
   D*|d*)
         echo "Deleting..."
         rm -r -v ~/local/bin
         mkdir -p ~/local/bin
         ;;
   M*|m*)
         echo "Merging..."
         ;;
   E*|e*)
         echo "Exiting..."
         exit
         ;;
       *)
         echo "Invalid option.  Exiting..."
         exit
         ;;
esac
   


cp -r -v ~/git/.local-bin/* ~/local/bin
#rm -r -v ~/local/bin/.git
cp -r -v ~/git/.bash_environment/.bash* ~/
exec bash
xit
#bash ~/local/bin/xit
