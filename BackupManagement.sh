BackupLog="$HOME/backup_log.txt"

echo "=== Backup Management (Arend Markies) ==="

read -p "Enter the day of the week (0-6, 0=Sunday, 1=Monday,...): " Day
case "$Day" in
   0) Day="Sun"
   echo "Sunday selected";;
   1) Day="Mon"
   echo "Monday selected";;
   2) Day="Tue"
   echo "Tuesday selected";;
   3) Day="Wed"
   echo "Wednesday selected";;
   4) Day="Thu"
   echo "Thursday selected";;
   5) Day="Fri"
   echo "Friday selected";;
   6) Day="Sat"
   echo "Saturday selected";;
   *)
      echo "Invalid day"
      exit 1
      ;;
esac
read -p "Enter the hour for backup (0-23): " Hour
read -p "Enter the minute for backup (0-59): " Minute
echo "the time you have selected $Hour:$Minute"
read -p "Enter the full path of the file to back up: " File
echo "you selected $File"
read -p "Enter the destination directory: " Destination
echo "you selected $Destination"

if [ ! -f "$File" ]; then
    echo "The file '$File' does not exist."
    exit 1
fi

mkdir -p "$Destination"

FileEscaped=$(echo "$File" | sed 's/ /\\ /g')
DestinationEscaped=$(echo "$Destination" | sed 's/ /\\ /g')

CronJob="$Minute $Hour * * $Day cp $FileEscaped $DestinationEscaped/$(basename "$File")_$(date +\%Y\%m\%d_\%H\%M\%S) && echo \"Backup completed at \$(date)\" >> $BackupLog"

(crontab -l 2>/dev/null | grep -Fv "$File" ; echo "$CronJob") | crontab -

echo ""
echo "Backup scheduled:"
echo "Day of week: $Day"
echo "Time: $Hour:$Minute"
echo "File: $File"
echo "Destination: $Destination"
echo ""

if [ -f "$BackupLog" ]; then
    echo "Last completed backup:"
    tail -n 1 "$BackupLog"
fi
