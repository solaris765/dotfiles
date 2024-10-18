#!/bin/bash

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Directory containing the installer scripts
INSTALLER_DIR="$SCRIPT_DIR/software_installers"

# Directory for log files
LOG_DIR="$SCRIPT_DIR/.software_installer_logs"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Array to store results
declare -A results

# Source all files starting with __
for file in "$INSTALLER_DIR"/__*.sh; do
    if [[ -f "$file" ]]; then
        source "$file"
    fi
done

# Function to display spinner
spinner() {
    local pid=$1
    local operation=$2
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r%-30s %c" "$operation" "${spin:$i:1}"
        sleep 0.1
    done
    printf "\r%-30s" "" # Erase the line
}


# Iterate over numbered scripts
for file in "$INSTALLER_DIR"/[0-9][0-9]_*.sh; do
    if [[ -f "$file" ]]; then
        base_name=$(basename "$file")
        operation="${base_name%.sh}"
        log_file="$LOG_DIR/${base_name%.sh}.log"
        
        # Start the operation in background and capture its PID
        bash "$file" > "$log_file" 2>&1 &
        pid=$!

        # Display spinner while operation is running
        spinner $pid "$operation"

        # Wait for the operation to complete
        wait $pid
        exit_status=$?

        # Determine status and store result
        if [ $exit_status -eq 0 ]; then
            status="\033[0;32m✔️\033[0m"
        else
            status="\033[0;31m❌\033[0m"
        fi

        # Store result
        results["$file"]="${status}"

        echo -ne "\033[K"  # Clear to end of line
        echo -ne "\033[0G" # Move cursor back to beginning
        echo -e "$base_name $status"
    fi
done

echo -e "\nLog files are available in $LOG_DIR"