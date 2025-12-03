
MainMenuFunction() {

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
        	                System_Status;;
                	2) 
                        	BackupManagement;;
	                3)
	                        Network;;
        	        4)
	                        service;;
        	        5)
	                        UserManagment ;;
        	        6)
	                        filesCheck;;
        	        7)
	                         exit 0;;
        	        *)
                	        echo "Invalid choice!!!";;
		esac
	done
}



System_Status() {

	menu() {
	    echo ""
	    echo " SYSTEM STATUS MENU "
	    echo "1) Display Memory Usage"
	    echo "2) Check CPU Temp"
	    echo "3) List Active System Processes"
	    echo "4) Stop a process"
	    echo "5) Exit"
	    echo ""
	}


	display_memory() {
	        echo ""
	        echo "Detailed Memory Usage"
	        free -m
	}



	cpu_temp() {
		echo ""
	        echo "CPU Temperature"
	        cpuTemp=$(cat /sys/class/thermal/thermal_zone0/temp)
	        cpuTempC=$(echo "$cpuTemp / 1000" | bc -l)

	        echo "CPU Temperature:  $cpuTempC °C"

	        if (( $(echo "$cpuTempC > 70" | bc -l) )); then
	                echo "WARNING!!! CPU Temperature is greater than 70!°C"
	        fi
	}

	list_systems() {
        	echo ""
	        echo "Active Processes"
	        top |head -n 20
	}


	process_menu() {

	        echo ""
	        echo " PROCESS MENU "
	        echo "1) Stop  process"
	        echo "2) Terminate a process"
	        echo "3) Exit"

	}

	stop_process() {

	        while true; do
        	        process_menu
	                read -p "Choose an option: " opt

	                case $opt in
	                        1)
	                                echo " ACTIVE PROCESSES: "
	                                printf "%-7s %-15s %-7s %-15s %-7s %-15s\n" \
	                                       "PID" "COMMAND" "PID" "COMMAND" "PID" "COMMAND"
	                                ps -u $USER -o pid:10,comm:25 --sort=pid --no-headers |column -t | paste - - - | column -t
	                                echo ""
	                                echo ""

	                                read -p "Enter the PID of the process to stop: " process

	                                kill -SIGSTOP "$process";;


        	                2)
                	                echo " ACTIVE PROCESSES: "
                        	        printf "%-7s %-15s %-7s %-15s %-7s %-15s\n" \
                                	       "PID" "COMMAND" "PID" "COMMAND" "PID" "COMMAND"
	                                ps -u $USER -o pid:10,comm:25 --sort=pid --no-headers | column -t | paste - - - | column -t
                	                echo ""


                        	        read -p "Enter the PID of the process to terminate: " process

                                	kill -SIGTERM "$process";;

	                        3)
	                                break;;
				*) echo "Invalid Option";;
    	            esac
	        done
	}


	while true; do
		menu
		read -p "Select an option: " opt

		case $opt in
	        1) display_memory;;
	        2) cpu_temp;;
	        3) list_systems ;;
	        4) stop_process;;
	        5) return ;;
	        *) echo "Invalid option" ;;
	    esac
	done

}


BackupManagement() {

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

}


Network() {

	menu() {

	        echo ""
	        echo " NETWORK MANAGEMENT MENU "
	        echo "1) Display Network Interfaces, IP Adresses & Default Gateways"
	        echo "2) Enable or Disable a Network Interface"
	        echo "3) Assign IP address to Network Card"
	        echo "4) Display Wi-Fi networks"
	        echo "5) Exit"
	        echo ""

	}

	display_networkInterfaces() {
	        echo ""

	        echo "Network Interfaces and their IP Addresses: "
	        for interface in $(ls /sys/class/net/); do
        	        ip_address=$(ip -o -4 addr show $interface | awk '{print $4}')
                	if [ -n "$ip_address" ]; then
	                        echo "Interface: $interface, IP Address: $ip_address"
	                else
	                        echo "Interface: $interface, No IP Address assigned"
	                fi
	        done

	        echo ""
	        echo "Default Gateways: "
	        ip route show default

	}

	enableOrDisable_Interface() {
	        echo ""
	        echo "Availabe Interfaces"
	        ip -brief addr show

        	echo ""

	        read -p "Enter an interface name: " interface

	        echo "1) Enable Interface"
	        echo "2) Disable Interface"
	        echo "3) Back"
	        read -p "Choose an option: " choice

	        case "$choice" in
	                1)
	                        sudo ip link set "$interface" up
	                        echo -e "$interface enabled.";;
	                2)
	                        sudo ip link set "$interface" down
	                        echo -e "$interface disabled.";;
	                3)
	                        return;;
	                *)
	                        echo "Invalid Option";;
	        esac

	}

	assign_IP() {
 	       echo ""
	        echo "Available Interfaces"
	        ip -brief addr show

	        read -p "Choose an interface: " interface

	        read -p "Enter an IP address: " ip

	        sudo ip addr add "$ip" dev "$interface"

	}

	display_wifiNetworks() {
		echo ""
	        echo "Available Wifi-Networks"

	        nmcli device wifi list

	        echo ""

	        echo "Connect to Wi-Fi"
	        read -p "Enter SSID: " ssid
	        read -sp "Enter Password: " pass
	        echo ""
	        nmcli device wifi connect "$ssid" password "$pass"

	}

	while true; do
	        menu
        	read -p "Select an option: " opt

	        case $opt in
	                1) display_networkInterfaces ;;
	                2) enableOrDisable_Interface;;
	                3) assign_IP;;
	                4) display_wifiNetworks;;
	                5) return ;;
        	        *) echo "Invalid option" ;;
	        esac
	done



}


service() {

	PS3="Please enter a number to choose the option you'd like to proceed with: "

	select serviceMgmt in ActiveStatus Start Stop Exit
	do
	case $serviceMgmt in

	ActiveStatus)
	echo "Selected option is: $serviceMgmt"
	systemctl list-units --type=service --state=running
	;;

	Start)
	read -p "What service would you like to start: " startsrvc
	 if systemctl list-unit-files | grep -q "$startsrvc.service"
	then
	sudo systemctl start "$startsrvc.service"
	echo "This serice $startsrvc exists and has been started!"
	else
	echo "This service $startsrvc does not exist"
	fi
	;;

	Stop)	
	read -p "What service would you like to stop: " stopsrvc
	if systemctl list-unit-files | grep -q "$stopsrvc.service"
	then
	sudo systemctl stop "$stopsrvc.service"
	echo "This service $stopsrvc exists and has been stopped!"
	else
	echo "This service $stopsrvc does not exist"
	fi
	;;
	Exit)
	echo "You have exited the program!"
	break
	;;
	*)
	echo "Not a valid option, you have exit the menu!"
	break
	;;
	esac
	done

}


UserManagment() {

	if [[ $EUID -ne 0 ]]; then
	    echo "This script must be run as root. Use: sudo bash \$0"
	    return
	fi

	check_fs() {
	    if mount | grep " / " | grep -q "(ro,"; then
	        echo "Root filesystem is read-only!"
	        echo "Fix with: sudo mount -o remount,rw /"
	        exit 1
	    fi
	}

	clear_locks() {
	    lock_files=("/etc/passwd.lock" "/etc/shadow.lock" "/etc/group.lock")

	    for f in "${lock_files[@]}"; do
	        if [[ -e $f ]]; then
	            if pgrep -f "useradd|usermod|userdel" >/dev/null; then
	                echo "Another user-modifying process is running, try again later"
	                exit 1
	            fi
	            echo "Removing stale lock: $f"
	            rm -f "$f"
	        fi
	    done
	}

	create_user() {
		check_fs
		clear_locks

		read -p "Enter new username: " username
		read -s -p "Enter password: " password
		echo

		if useradd -m "$username"; then
			echo "$username:$password" | chpasswd || {
				echo "Failed to set password for '$username'"
				return
			}
		        echo "User '$username' created"
		else
		        echo "Failed to create user"
		fi
	}

	grant_root() {
		read -p "Enter username: " username
		usermod -aG sudo "$username" && echo "The user $username currently has no sudo privileges"
		echo "Now adding sudo privileges"
		echo "$username now has sudo privileges"
	}

	delete_user() {
	    read -p "Enter username to delete: " username

	    check_fs
	    clear_locks

	    echo "Checking for active processes"

	    if pgrep -u "$username" >/dev/null 2>&1; then
	        echo "User '$username' has running processes, now terminating"
	        pkill -KILL -u "$username"
	        sleep 1
	    fi

	    echo "Deleting user '$username' (suppressing harmless warnings)"
	    userdel -r "$username" 2>/dev/null

	    if id "$username" >/dev/null 2>&1; then
	        echo "Failed to delete user '$username'"
	        echo "Possible causes: "
	        echo "The user is running a systemd service"
	        echo "Another process recreated the user"
	        echo "Filesystem or permission issue"
	    else
	        echo "User '$username' deleted successfully"
	    fi
	}


	show_connected_users() {
	    echo "All logged-in users: "
	    who
	}

	disconnect_user() {
	    read -p "Enter username to disconnect: " username
	    pkill -KILL -u "$username"
	    echo "User '$username' disconnected"
	}

	show_user_groups() {
	    read -p "Enter username: " username
	    groups "$username"
	}

	change_membership() {
	    read -p "Enter username: " username
	    read -p "Enter primary group: " pgroup
	    read -p "Enter additional groups (comma-separated): " agroups

	    usermod -g "$pgroup" -G "$agroups" "$username" \
	        && echo "Updated group membership for '$username'"
	}

	while true; do
	    echo ""
	    echo "===== User Management (Arend Markies) ====="
	    echo "1) Create new user"
	    echo "2) Grant root privileges"
	    echo "3) Delete user"
	    echo "4) Show connected users"
	    echo "5) Disconnect a user"
	    echo "6) Show user's groups"
	    echo "7) Change user's group membership"
	    echo "8) Exit"
	    read -p "Choose an option (1–8): " choice
	    echo ""

	    case "$choice" in
	        1) create_user ;;
	        2) grant_root ;;
	        3) delete_user ;;
	        4) show_connected_users ;;
	        5) disconnect_user ;;
	        6) show_user_groups ;;
	        7) change_membership ;;
	        8) echo "Goodbye!"; exit 0 ;;
	        *) echo "Invalid option" ;;
	    esac
	done
}


filesCheck() {

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

}


MainMenuFunction
