#!/usr/bin/env sh

# Load the configuration file
CONFIG_FILE="locify.config.sh"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Error: Configuration file not found! Please run 'init-locales' first."
  exit 1
fi

# Read configuration
# shellcheck disable=SC1091
. "$CONFIG_FILE"

# Convert LOCALES array to space-separated string if it's in array format
LOCALES_STR=$(echo "${LOCALES[@]}" | tr ' ' ' ')

# Validate that the JSON files exist
for locale in $LOCALES_STR; do
  locale_file="$LOCALES_DIR/$locale.json"
  if [ ! -f "$locale_file" ]; then
    echo "❌ Error: Missing locale file: $locale_file"
    exit 1
  fi
done

# Function to add localization
add_localization() {
  echo "Enter the JSON key (e.g., sign_in.header.title):"
  read key

  # Convert key to uppercase
  FORMATTED_KEY=$(echo "$key" | tr '[:lower:]' '[:upper:]')

  for locale in $LOCALES_STR; do
    locale_file="$LOCALES_DIR/$locale.json"

    echo "Enter the translation for $locale ($FORMATTED_KEY):"
    read translation

    # Function to update JSON files
    update_json() {
      file="$1"
      key="$2"
      value="$3"

      # Convert keys to array using POSIX-compatible method
      IFS='.' read -r -a keys <<< "$key"

      # JQ script generation
      jq_script="."
      path=""

      for k in "${keys[@]}"; do
        path="$path[\"$k\"]"
        jq_script="$jq_script | .${path} //= {}"
      done

      jq_script="$jq_script | .${path} = \"$value\""

      # Update JSON file
      jq "$jq_script" "$file" > tmp.json && mv tmp.json "$file"
    }

    update_json "$locale_file" "$FORMATTED_KEY" "$translation"
    echo "✅ Updated: $locale_file"
  done
}

# Loop for multiple entries
while true; do
  add_localization

  echo "Do you want to add another localization? (y/n):"
  read answer

  case "$answer" in
    y|Y) continue ;;
    *) break ;;
  esac
done