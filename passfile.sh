#!/bin/bash
#makepasslist
#filter huge files to something workable

if [ $USER == 'root' ]; then
echo "Root privileges granted..."
else
echo "Log in as root at try again.  Exiting.."
exit 1
fi

logfile='/home/shawn/local/var/passfilelog.txt'
origfile='/home/shawn/local/origfile.txt'
workfile='/media/shawn/de7aa7cd-d528-4616-aedc-affebe765e3e/workfile.txt'
tempfile='/home/shawn/local/tmp/tempfile.txt'
newsfile='/media/shawn/de7aa7cd-d528-4616-aedc-affebe765e3e/newsfile.txt'
maxx=64
minn=8
whitetrail=\'s/\s*\$//\'
whitefollo=\'s/\^\s*//\'
toolong=\'/.\{$maxx\}/d\'
tooshort=\'/.\{$minn\}/\!d\'
perlascii=\'^\[\[:ascii:\]\]\+\$\'

timestamp() { echo $(date); }


if [ -f $logfile ]; then
rm $logfile
fi

upyourdate() {
echo "$mystep" | tee -a "$logfile"
}

status() {
echo "$mystep is completed. Check above for errors.  Now updating wordcount..."
wordcount=$(wc -l $tempfile)
echo "Current file is $wordcount words long." | tee -a "$logfile"
timestamp | tee -a "$logfile"
}

errck() {
if [ $? == 0 ]; then
echo "Successfully completed operation.  Exit Code 0.  Continuing."  | tee -a "$logfile"
else
echo "Non Zero exit code.  ($?).  Proceeding anyway..."  | tee -a "$logfile"
fi
}


timestamp
#make a backup
mystep="Creating a backup"
upyourdate
cp -v $origfile $tempfile
cp -v $origfile $workfile
errck

#prune trailing whitespace
status
mystep="Pruning trailing whitespaces"
upyourdate
nice -n -10 cat "$workfile" | parallel --pipe sed -E -e $whitetrail > "$tempfile"
errck
cp -v "$tempfile" "$newsfile"
errck


#prunce preceding whitespace
status
mystep="Pruning preceding whitespace"
upyourdate
nice -n -10 cat "$newsfile" | parallel --pipe sed -E -e $whitefollo > "$tempfile"
errck
cp -v "$tempfile" "$workfile"
errck

#prune long lines
status
mystep=$(echo "Pruning lines longer than $maxx characters")
upyourdate
#nice -n -10 cat "$workfile" | parallel --pipe sed -E -e $toolong > "$tempfile"
nice -n -10 sed -i -e '/.\{64\}/d' $tempfile
errck
cp -v "$tempfile" "$newsfile"
errck

#prune short lines
status
mystep=$(echo "Pruning lines shorter than $minn characters")
upyourdate
#nice -n -10 cat "$newsfile" | parallel --pipe sed -E -e $tooshort > "$tempfile"
nice -n -10 sed -i -e '/.\{8\}/!d' $tempfile
errck
cp -v "$tempfile" "$workfile"
errck

#prune NON-ASCII lines
status
mystep="pruning non ascii characters"
upyourdate
nice -n -10 cat "$workfile" | parallel --pipe grep -P '^[[:ascii:]]+$' > "$tempfile"
errck
cp -v "$tempfile" "$newsfile"
errck


#sort the whole kit & kaboodle
status
mystep="Sorting unique entries... "
upyourdate
LC_ALL=C sort --parallel=40 -u -o "$tempfile" "$newsfile"
errck
cp -v "$tempfile" "$workfile"
errck



#sort the whole kit & kaboodle
status
mystep="Alphabetizing unique entries"
upyourdate
LC_ALL=C sort --parallel=40 -o "$tempfile" "$workfile"
errck
cp -v "$tempfile" "$newsfile"
errck

status

echo "job is complete and can be found in $newfile"
echo "now destroying all files on system..."

exit 0


nice -n -10 sed -i -e 's/^\s*//' tempfile.txt
nice -n -10 cat testfile | parallel --pipe sed -E -e 's/^\s*//g' > test1
cat workfile.txt | grep -E '.*\@.*\.+'

nice -n -10 sed -i -e 's/\s+*$//' testfile



#  nice -n -10 cat testfile | parallel --pipe sed -E -e 's/^s*//' > tempfile


nice -n -10 cat testfile | parallel --pipe sed -E 's/^\s+//' > test1
nice -n -10 cat testfile | parallel --pipe grep -P '^[[:ascii:]]+$' > test1
's/^s*//'



nice -n -10 cat testfile | parallel --pipe LC_ALL=C grep -P '^[[:ascii:]]+$' > test1




  









