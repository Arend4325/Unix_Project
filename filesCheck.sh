PS3="Please enter a number to choose the option you'd like to proceed with: "
select fileMgmt in findFile LargestFiles OldestFiles Exit
do
case $fileMgmt in
findFile)
read -p "Please enter username: " user
read -p "Please enter file name: " file
if id "$user" &>/dev/null; then
echo "User '$user' exists."
if [ -f "$file" ]
then
echo "$file has been found"
else
echo "$file does not exist!"
fi
else
echo "$user does not exist!"
fi
;;
LargestFiles)
largest=$(du -a -h "$HOME" | sort -rh | head)
echo "The 10 largest files are: "
echo "$largest"
;;
OldestFiles)
oldest=$(ls -lt "$HOME" | tail -10)
echo "The 10 oldest files are: "
echo "$oldest"
;;
Exit)
echo "You have exited the program."
break
;;
*)
echo "Invalid option!"
break
esac
done
