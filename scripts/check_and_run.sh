#!/bin/bash

SCRIPT_TO_RUN="/path/to/your/script.sh"

if [ -f "$SCRIPT_TO_RUN" ]; then
    echo "Running script: $SCRIPT_TO_RUN"
    bash "$SCRIPT_TO_RUN"
    EXIT_STATUS=$?  # Capture the exit status of the called script
else
    echo "Script not found: $SCRIPT_TO_RUN. Continuing without running the script."
    exit 0  # Exit with 0 to indicate success if the script is not found
fi

# Exit with the same status as the called script
exit $EXIT_STATUS
