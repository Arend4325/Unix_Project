
while true; do

	echo ""
	echo "Main Menu"
	echo "1) System Status"
	echo "2) Backup Management"
	echo "3) Network Management"
	echo "4) Service Management"
	echo "5) User Management"
	echo "6) File Management"
	echo "7) Exit the program"
	echo ""

	read -p "Enter your choice: " choice

	case $choice in
		1)
			bash System_Status.sh;;
		2) 
			bash BackupManagement.sh;;
		3) 
			bash Network.sh;;
		4) 
			bash service.sh;;
		5) 
			bash UserManagment.sh;;
		6) 
			bash filesCheck.sh;;
		7)
			 exit 0;;
		*)
			echo "Invalid choice!!!";;
	esac
done
