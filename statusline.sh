#!/usr/bin/env bash

GREEN=$'\e[32m'
YELLOW=$'\e[33m'
ORANGE=$'\e[38;5;208m'
RED=$'\e[31m'
RESET=$'\e[0m'

json=$(cat 2>/dev/null) || exit 0
[[ -z "$json" ]] && exit 0

parse() {
  printf '%s' "$json" | jq -r "$1 // empty" 2>/dev/null
}

color_usage() {
  local val="$1" low="$2" mid="$3"
  if [[ -z "$val" ]]; then
    printf '%s' '—'
    return
  fi
  local int="${val%.*}"
  if   (( int < low )); then printf '%s' "${GREEN}${val}%${RESET}"
  elif (( int < mid )); then printf '%s' "${YELLOW}${val}%${RESET}"
  else                       printf '%s' "${RED}${val}%${RESET}"
  fi
}

color_7day() {
  local val="$1"
  if [[ -z "$val" ]]; then
    printf '%s' '—'
    return
  fi
  local int="${val%.*}"
  if   (( int < 40 )); then printf '%s' "${GREEN}${val}%${RESET}"
  elif (( int < 70 )); then printf '%s' "${YELLOW}${val}%${RESET}"
  else                      printf '%s' "${ORANGE}${val}%${RESET}"
  fi
}

round() { [[ -n "$1" ]] && printf '%.0f' "$1" 2>/dev/null || printf '%s' "$1"; }

model=$(parse '.model.display_name')
ctx=$(round "$(parse '.context_window.used_percentage')")
five_h=$(round "$(parse '.rate_limits.five_hour.used_percentage')")
seven_d=$(round "$(parse '.rate_limits.seven_day.used_percentage')")

[[ -n "$model"   ]] && part_model="Modèle: ${model}"                       || part_model="Modèle: —"
[[ -n "$ctx"     ]] && part_ctx="Contexte: $(color_usage "$ctx" 50 80)"    || part_ctx="Contexte: —"
[[ -n "$five_h"  ]] && part_5h="5h: $(color_usage "$five_h" 50 80)"        || part_5h="5h: —"
[[ -n "$seven_d" ]] && part_7d="7j: $(color_7day "$seven_d")"              || part_7d="7j: —"

printf '%s\n' "${part_model} │ ${part_ctx} │ ${part_5h} │ ${part_7d}"
