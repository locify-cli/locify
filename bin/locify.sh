#!/usr/bin/env sh

# Get the directory of the script
BASE_DIR="$(cd -- "$(dirname "$(realpath "$0")")" >/dev/null 2>&1 || exit; pwd -P)"

# Check if running from global install
if [ ! -d "$BASE_DIR/scripts" ]; then
  # If running from npm global install, go one level up
  BASE_DIR="$(cd "$BASE_DIR/.." >/dev/null 2>&1 || exit; pwd -P)"
fi

# Define the scripts directory
SCRIPTS_DIR="$BASE_DIR/scripts"

# Ensure scripts directory exists
if [ ! -d "$SCRIPTS_DIR" ]; then
  echo "❌ Error: Scripts directory not found at $SCRIPTS_DIR"
  exit 1
fi

# Display menu
show_menu() {
  clear
  echo "===================================="
  echo "             🚀 LOCIFY               "
  echo "===================================="
  echo ""
  echo "Available commands:"
  echo "  1) Init           - Initialize locales JSON files"
  echo "  2) Reset          - Remove CLI configuration & locale JSON files"
  echo "  3) Add            - Add a new translation key to locales JSON"
  echo "  4) Edit           - Modify a translation value in locales JSON"
  echo "  5) Delete         - Delete a translation key from locales JSON"
  echo "  6) Exit"
  echo ""
}

# Function to execute selected command
execute_command() {
  case "$1" in
    1) sh "$SCRIPTS_DIR/init.sh" ;;
    2) sh "$SCRIPTS_DIR/reset.sh" ;;
    3) sh "$SCRIPTS_DIR/add.sh" ;;
    4) sh "$SCRIPTS_DIR/edit.sh" ;;
    5) sh "$SCRIPTS_DIR/delete.sh" ;;
    6) echo "👋 Exiting..."; exit 0 ;;
    *) echo "❌ Invalid option. Please try again." ;;
  esac
}

# Menu loop
while true; do
  show_menu
  printf "Enter a number and press ENTER: "
  read user_input

  execute_command "$user_input"

  # Wait for user input before showing the menu again
  printf "\nPress ENTER to continue..."
  read _
done