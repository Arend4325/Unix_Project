PS3="Please enter a number to choose the option you'd like to proceed with: "

select serviceMgmt in ActiveStatus Start Stop Exit
do
case $serviceMgmt in

ActiveStatus)
echo "Selected option is: $serviceMgmt"
systemctl list-units --type=service | grep "running"
;;

Start)
read -p "What service would you like to start: " startsrvc
if systemctl list-unit-files "$startsrvc.service" &>/dev/null
then
echo "This serice $startsrvc exists and has been started!"
sudo systemctl start "$startsrvc"
else
echo "This service $startsrvc does not exist"
fi
;;

Stop)
read -p "What service would you like to stop: " stopsrvc
if systemctl list-unit-files "$stopsrvc.service" &>/dev/null
then
echo "This service $stopsrvc exists and has been stopped!"
sudo systemctl stop "$stopsrvc"
else
echo "This service $stopsrvc does not exist"
fi
;;

Exit)
echo "You have exited the program."
break
;;
*)
echo "Not a valid option, you have exit the menu!"
;;
esac
done
