#!/usr/bin/env sh

# Path to the JSON configuration file
CONFIG_FILE="locify.config.json"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Error: Configuration file not found! Please run 'init-locales' first."
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

# Prompt for the key to modify
echo "Enter the JSON key to modify (e.g., sign_in.header.title):"
read key

# Convert the key to uppercase
FORMATTED_KEY=$(echo "$key" | tr '[:lower:]' '[:upper:]')

# Function to check if a key exists in a JSON file
key_exists() {
  file="$1"
  key="$2"

  # Convert keys to array (POSIX sh)
  IFS='.' read -r -a keys <<< "$key"

  # Construct JQ path
  path=""
  for k in "${keys[@]}"; do
    path="$path[\"$k\"]"
  done

  # Check if the key exists in the JSON file
  if jq -e ".${path} // empty" "$file" >/dev/null 2>&1; then
    return 0  # Exists
  else
    return 1  # Does not exist
  fi
}

# Verify if the key exists in all locale files
for locale in $LOCALES; do
  locale_file="$LOCALES_DIR/$locale.json"
  if ! key_exists "$locale_file" "$FORMATTED_KEY"; then
    echo "❌ Error: Key '$FORMATTED_KEY' not found in $locale_file"
    exit 1
  fi
done

# Prompt for new translations for each locale
translations=""
for locale in $LOCALES; do
  echo "Enter the new translation for $locale ($FORMATTED_KEY):"
  read value
  translations="$translations$locale:$value\n"
done

# Function to modify a key in the JSON file
modify_json() {
  file="$1"
  key="$2"
  value="$3"

  # Convert key into an array
  IFS='.' read -r -a keys <<< "$key"

  # Construct the JQ update command
  jq_script="."
  path=""

  for k in "${keys[@]}"; do
    path="$path[\"$k\"]"
  done

  jq_script="$jq_script | .${path} = \"$value\""

  # Update the JSON file
  jq "$jq_script" "$file" > tmp.json && mv tmp.json "$file"
}

# Update each locale JSON file
echo "$translations" | while IFS=: read -r locale value; do
  locale_file="$LOCALES_DIR/$locale.json"
  modify_json "$locale_file" "$FORMATTED_KEY" "$value"
  echo "✅ Updated: $locale_file"
done

echo "✅ Localization modified successfully!"