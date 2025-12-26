#!/bin/bash

URL=$(curl -s https://slack.com/downloads/instructions/linux\?ddl\=1\&build\=deb | grep -oP 'href="\K[^"]*slack-desktop[^"]*\.deb')
LATEST=$(echo "$URL" | grep -oP 'slack-desktop-\K[0-9.]+' | tr -d '[:space:]')
echo "$LATEST"

REPO="${GITHUB_REPOSITORY:-vgovras/slack-appimage}"
LAST_TAG=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null | grep -o '"tag_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/' || echo "")
LAST=$(echo "$LAST_TAG" | sed 's/^v//' | tr -d '[:space:]')

echo "repo: ${LAST:-0.0.0} current: ${LATEST:-0.0.0}" >&2

if [ -z "$LAST" ] || [ "$LATEST" != "$LAST" ]; then
  exit 0
else
  exit 1
fi

