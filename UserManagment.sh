if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use: sudo bash \$0"
    exit 1
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
