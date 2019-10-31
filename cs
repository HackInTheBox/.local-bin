#!/bin/bash
# cs
# make a contact sheet out of images in a folder

targetfolder="$1"
montage -geometry 300x300 -label "%f" "${targetfolder}/*" "${targetfolder}/contact_sheet.jpg"
erck=$?
if [ ${erck} == 0 ]; then
   echo "Successful."
else
   echo "Possible error. Investigate."
fi

exit 