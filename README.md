# simple-status-line

Affiche une ligne d'état dans Claude Code avec les métriques d'utilisation en temps réel.

```
Modèle: claude-sonnet-4-5 │ Contexte: 23% │ 5h: 41% │ 7j: 12%
```

## Métriques

| Champ | Source JSON | Couleurs |
|---|---|---|
| Modèle | `model.display_name` | blanc |
| Contexte | `context_window.used_percentage` | vert < 50 · jaune 50–79 · rouge ≥ 80 |
| 5h | `rate_limits.five_hour.used_percentage` | vert < 50 · jaune 50–79 · rouge ≥ 80 |
| 7j | `rate_limits.seven_day.used_percentage` | vert < 40 · jaune 40–69 · orange ≥ 70 |

## Installation

```bash
./deploy.sh
```

Relancer Claude Code. C'est tout.

## Dépendances

- bash
- jq

## Fichiers

```
statusline.sh   script appelé par Claude Code à chaque rafraîchissement
deploy.sh       copie le script et patch settings.json
```
