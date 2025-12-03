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
				echo "============= ACTIVE PROCESSES ============="
				printf "%-7s %-15s %-7s %-15s %-7s %-15s\n" \
				       "PID" "COMMAND" "PID" "COMMAND" "PID" "COMMAND"
				ps -u $USER -o pid:10,comm:25 --sort=pid --no-headers | column -t | paste - - - | column -t
				echo "============================================"
				echo ""

				read -p "Enter the PID of the process to stop: " process

				kill -SIGSTOP "$process";;


			2)
				echo "============= ACTIVE PROCESSES ============="
                                printf "%-7s %-15s %-7s %-15s %-7s %-15s\n" \
                                       "PID" "COMMAND" "PID" "COMMAND" "PID" "COMMAND"
                                ps -u $USER -o pid:10,comm:25 --sort=pid --no-headers | column -t | paste - - - | column -t
                                echo "============================================"
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
        1) display_memory ;;
        2) cpu_temp ;;
        3) list_systems ;;
        4) stop_process ;;
        5) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
