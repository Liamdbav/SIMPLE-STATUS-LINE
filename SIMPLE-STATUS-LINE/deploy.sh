#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude/simple-status-line"
SETTINGS="$HOME/.claude/settings.json"

GREEN=$'\e[32m'
YELLOW=$'\e[33m'
RED=$'\e[31m'
BOLD=$'\e[1m'
RESET=$'\e[0m'

ok()   { printf "${GREEN}✓${RESET} %s\n" "$1"; }
warn() { printf "${YELLOW}!${RESET} %s\n" "$1"; }
fail() { printf "${RED}✗${RESET} %s\n" "$1" >&2; exit 1; }

echo ""
echo "${BOLD}=== Déploiement simple-status-line ===${RESET}"

# --- Dépendances ---
command -v jq &>/dev/null || fail "jq est requis mais introuvable (brew install jq)"
ok "jq disponible"

# --- Copie du script ---
mkdir -p "$TARGET_DIR"
cp "$SCRIPT_DIR/statusline.sh" "$TARGET_DIR/statusline.sh"
chmod +x "$TARGET_DIR/statusline.sh"
ok "statusline.sh → $TARGET_DIR/statusline.sh"

# --- Fusion dans settings.json ---
if [[ ! -f "$SETTINGS" ]]; then
  printf '{}' > "$SETTINGS"
  warn "settings.json créé (était absent)"
fi

jq . "$SETTINGS" > /dev/null 2>&1 || fail "settings.json existant est invalide — abandon"

PATCH='{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/simple-status-line/statusline.sh",
    "padding": 1,
    "refreshInterval": 10
  }
}'

MERGED=$(jq --argjson patch "$PATCH" '$patch * .' "$SETTINGS")
printf '%s\n' "$MERGED" > "$SETTINGS"

jq . "$SETTINGS" > /dev/null 2>&1 || fail "settings.json invalide après fusion — vérifier manuellement"
ok "statusLine fusionné dans $SETTINGS"

# --- Test rapide du script ---
RESULT=$(printf '%s' '{"model":{"display_name":"test"},"context_window":{"used_percentage":25},"rate_limits":{"five_hour":{"used_percentage":10},"seven_day":{"used_percentage":10}}}' \
  | "$TARGET_DIR/statusline.sh" 2>&1)
[[ "$RESULT" == *"Modèle: test"* ]] || fail "Le script ne produit pas la sortie attendue"
ok "Test du script passé"

echo ""
echo "${BOLD}Déploiement terminé.${RESET}"
echo "Relance Claude Code pour activer la status line."
echo ""
