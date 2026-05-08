# simple-status-line

> Ligne d'état pour [Claude Code](https://claude.ai/code) affichant les métriques d'utilisation en temps réel, avec coloration selon les seuils.

```
Modèle: claude-sonnet-4-5 │ Contexte: 23% │ 5h: 41% │ 7j: 12%
```

---

## Métriques affichées

| Champ | Source JSON | Couleurs |
|---|---|---|
| **Modèle** | `model.display_name` | blanc |
| **Contexte** | `context_window.used_percentage` | 🟢 < 50 · 🟡 50–79 · 🔴 ≥ 80 |
| **5h** | `rate_limits.five_hour.used_percentage` | 🟢 < 50 · 🟡 50–79 · 🔴 ≥ 80 |
| **7j** | `rate_limits.seven_day.used_percentage` | 🟢 < 40 · 🟡 40–69 · 🟠 ≥ 70 |

Les valeurs manquantes ou nulles s'affichent `—` sans erreur.

---

## Prérequis

- **bash**
- **jq** — `brew install jq` (macOS) · `apt install jq` (Debian/Ubuntu)
- Claude Code

---

## Installation

```bash
git clone https://github.com/<votre-nom>/simple-status-line
cd simple-status-line
./deploy.sh
```

Relancez Claude Code. C'est tout.

---

## Ce que fait `deploy.sh`

1. Vérifie que `jq` est disponible
2. Copie `statusline.sh` dans `~/.claude/simple-status-line/`
3. Ajoute le bloc suivant dans `~/.claude/settings.json` (sans écraser les clés existantes) :

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/simple-status-line/statusline.sh",
    "padding": 1,
    "refreshInterval": 10
  }
}
```

4. Lance un test de fumée pour valider la sortie du script

Le script est **idempotent** : si `statusLine` existe déjà dans votre `settings.json`, il est ignoré.

---

## Installation manuelle

```bash
mkdir -p ~/.claude/simple-status-line
cp statusline.sh ~/.claude/simple-status-line/
chmod +x ~/.claude/simple-status-line/statusline.sh
```

Puis ajoutez le bloc `statusLine` ci-dessus dans `~/.claude/settings.json`.

---

## Fichiers

```
statusline.sh   script invoqué par Claude Code à chaque rafraîchissement
deploy.sh       installeur — copie le script et patche settings.json
```
