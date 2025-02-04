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

# Confirm deletion
echo "⚠️  Warning: This will delete all locale JSON files in $LOCALES_DIR and remove the configuration."
printf "Are you sure? (y/N): "
read confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "❌ Clear operation cancelled."
  exit 0
fi

# Delete locale JSON files
for locale in $LOCALES; do
  locale_file="$LOCALES_DIR/$locale.json"
  if [ -f "$locale_file" ]; then
    rm "$locale_file"
    echo "🗑 Deleted: $locale_file"
  fi
done

# Remove the locale directory if empty
if [ -d "$LOCALES_DIR" ] && [ -z "$(find "$LOCALES_DIR" -type f 2>/dev/null)" ]; then
  rmdir "$LOCALES_DIR"
  echo "🗑 Deleted empty directory: $LOCALES_DIR"
fi

# Remove the configuration file
rm "$CONFIG_FILE"
echo "🗑 Deleted configuration file: $CONFIG_FILE"

echo "✅ Locale data cleared! You can now run 'locify init' again if needed."