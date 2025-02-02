# 🌍 Locify CLI

**Locify** is a simple and powerful command-line tool for managing localization JSON files. With Locify, you can easily initialize, add, edit, and delete localization keys from your JSON files without manually modifying them. This makes managing translations for your applications much more efficient!

## 🚀 Features

- **Initialize locales**: Set up your localization JSON files in seconds.
- **Add new translations**: Easily insert new translation keys into JSON files.
- **Edit existing translations**: Modify the value of any existing localization key.
- **Delete translations**: Remove unwanted localization keys safely.
- **Cross-platform support**: Works on **macOS, Linux, and Windows**.

---

## 📦 Installation

### Install globally via npm

```sh
npm install -g locify-cli
```

### Verify installation

```sh
locify
```

---

## 🎯 Usage

### Show the interactive CLI menu

```sh
locify
```

This will open the Locify CLI menu:

```
====================================
          🚀 LOCIFY CLI
====================================

Available commands:
  1) Init         - Initialize locales JSON files
  2) Reset        - Remove CLI configuration & locale JSON files
  3) Add          - Add a new translation key to locales JSON
  4) Edit         - Modify a translation value in locales JSON
  5) Delete       - Delete a translation key from locales JSON
  6) Exit

Enter a number and press ENTER:
```

## Example Usage

### Initializing Locales

First, initialize your localization JSON files:

```sh
locify
```

_Select `Init` from the menu and specify locale codes (e.g., `en,hu,fr`)._

### Adding a Translation

After running `locify`, select `Add` from the CLI menu and enter:

```
Enter the JSON key (e.g., home.content.body): home.content.body
Enter the translation for en (HOME.CONTENT.BODY): Welcome Home!
Enter the translation for hu (HOME.CONTENT.BODY): Üdv itthon!
```

This updates your JSON files as follows:

**en.json:**

```json
{
  "HOME": {
    "CONTENT": {
      "BODY": "Welcome Home!"
    }
  }
}
```

**hu.json:**

```json
{
  "HOME": {
    "CONTENT": {
      "BODY": "Üdv itthon!"
    }
  }
}
```

### Editing a Translation

Run `locify` and select `Edit` from the CLI menu. Then update an existing key:

```
Enter the JSON key to modify: home.content.body
Enter the new translation for en (HOME.CONTENT.BODY): Welcome!
Enter the new translation for hu (HOME.CONTENT.BODY): Üdv!
```

### Deleting a Translation

Run `locify` and select `Delete`. Enter the key you want to remove:

```
Enter the JSON key to delete: home.content.body
```

This removes the corresponding entries from all locale JSON files.

---

## Resetting Locify Configuration

If you need to reset your configuration and locale files, run `locify`, select `Reset`, and confirm deletion.
