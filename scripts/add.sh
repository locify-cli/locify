#!/usr/bin/env sh

# Path to the JSON configuration file
CONFIG_FILE="locify.config.json"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Error: Configuration file not found! Please run 'locify init' first."
  exit 1
fi

# Read values from the JSON config using `jq`
LOCALES_DIR=$(jq -r '.LOCALES_DIR' "$CONFIG_FILE")
LOCALES=$(jq -r '.LOCALES[]' "$CONFIG_FILE")

# Validate that the JSON files exist
for locale in $LOCALES; do
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

  for locale in $LOCALES; do
    locale_file="$LOCALES_DIR/$locale.json"

    echo "Enter the translation for $locale ($FORMATTED_KEY):"
    read translation

    # Function to update JSON files
    update_json() {
      file="$1"
      key="$2"
      value="$3"

      # Convert keys to an array using POSIX-compatible method
      IFS='.' read -r -a keys <<< "$key"

      # Generate JQ script
      jq_script="."
      path=""

      for k in "${keys[@]}"; do
        path="$path[\"$k\"]"
        jq_script="$jq_script | .${path} //= {}"
      done

      jq_script="$jq_script | .${path} = \"$value\""

      # Update the JSON file
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