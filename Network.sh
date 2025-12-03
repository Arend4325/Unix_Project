
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
		1) display_networkInterfaces;;
		2) enableOrDisable_Interface;;
		3) assign_IP;;
		4) display_wifiNetworks;;
		5) exit 0;;
		*) echo "Invalid option";;
	esac
done
