#!/usr/bin/env sh

CONFIG_FILE="locify.config.json"

create_config() {
  locales_path=$1
  locales=$2

  echo "{
  \"LOCALES_DIR\": \"$locales_path\",
  \"LOCALES\": [$(echo $locales | sed 's/ /", "/g' | sed 's/^/"/' | sed 's/$/"/')]
}" > "$CONFIG_FILE"

  echo "✅ Configuration saved in $CONFIG_FILE"
}

init_new_locales() {
  echo "Enter the JSON file names for locales (comma-separated, e.g., en,hu,fr):"
  read locales_input

  # Convert to a space-separated list
  locales=$(echo "$locales_input" | tr ',' ' ')

  echo "Enter the path where the locale files should be stored (e.g., src/localization/locales):"
  read locales_path

  # Ensure directory exists
  mkdir -p "$locales_path"

  # Create locale JSON files
  for locale in $locales; do
    locale_file="$locales_path/$locale.json"

    if [ ! -f "$locale_file" ]; then
      echo "{}" > "$locale_file"
      echo "✅ Created: $locale_file"
    else
      echo "⚠️ Warning: $locale_file already exists, skipping..."
    fi
  done

  create_config "$locales_path" "$locales"
}

init_existing_locales() {
  echo "Enter the path to the existing locale files (e.g., src/localization/locales):"
  read locales_path

  # Check if the directory exists
  if [ ! -d "$locales_path" ]; then
    echo "❌ Error: Directory not found at $locales_path"
    exit 1
  fi

  # Find all .json files in the directory
  locales=$(find "$locales_path" -maxdepth 1 -name "*.json" -exec basename {} .json \; | tr '\n' ' ')

  if [ -z "$locales" ]; then
    echo "❌ Error: No .json files found in $locales_path"
    exit 1
  fi

  echo "✅ Found locales: $locales"
  
  create_config "$locales_path" "$locales"
}

init_locales() {
  case "$1" in
    --new|-n)
      echo "Initializing new locales..."
      init_new_locales
      ;;
    --link|-l)
      echo "Initializing with existing locales..."
      init_existing_locales
      ;;
    *)
      echo "Would you like to initialize new locale files? (y/n)"
      read answer
      case "$answer" in
        y|Y) init_new_locales ;;
        n|N) init_existing_locales ;;
        *) echo "❌ Invalid input. Please enter 'y' or 'n'."; exit 1 ;;
      esac
      ;;
  esac
}

# Check for command-line arguments
if [ "$#" -gt 0 ]; then
  init_locales "$1"
else
  init_locales
fi