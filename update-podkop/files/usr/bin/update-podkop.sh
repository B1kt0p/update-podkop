#!/bin/sh
# podkop config updater (no russian text - works everywhere)

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'



echo -e "${YELLOW}Downloading new podkop config...${NC}"

# read config
REPO_URL="$(uci get update-podkop.settings.url)"
TOKEN="$(uci get update-podkop.settings.token)"

# check config
if [ -z "$REPO_URL" ] || [ -z "$TOKEN" ]; then
    echo "Error: repo URL or token not set in /etc/config/update-podkop"
    exit 1
fi


cd /tmp || { echo -e "${RED}Failed to cd /tmp${NC}"; exit 1; }

curl -L -H "Authorization: token $TOKEN" -o podkop-new "$REPO_URL"

# Check: file exists and is not empty
if [ ! -f podkop-new ] || [ ! -s podkop-new ]; then
    echo "${RED}Download failed (no file or empty)!${NC}"
    rm -f podkop-new 2>/dev/null
    exit 1
fi

# Read the first line
first_line="$(head -n 1 podkop-new 2>/dev/null)"

# Validate header tag
if [ "$first_line" != "# valid-podkop" ]; then
    echo "${RED}Invalid podkop file!${NC}"
    rm -f podkop-new 2>/dev/null
    exit 1
fi

echo -e "${GREEN}Download OK${NC}"
echo -e "${YELLOW}CHECK Youtubeunblock...${NC}"
if /etc/init.d/youtubeunblock status >/dev/null 2>&1; then
    echo -e "${YELLOW}Stopping youtubeunblock...${NC}"
    /etc/init.d/youtubeunblock stop
    /etc/init.d/youtubeunblock disable
fi
echo -e "${GREEN}Youtubeunblock OK${NC}"

[ -f /etc/config/podkop ] && cp /etc/config/podkop /etc/config/podkop.old && \
    echo -e "${GREEN}Backup created (podkop.old)${NC}"

cp /tmp/podkop-new /etc/config/podkop || { echo -e "${RED}Copy failed!${NC}"; exit 1; }

if command -v podkop >/dev/null 2>&1; then
    podkop restart
elif [ -x /etc/init.d/podkop ]; then
    podkop restart
fi

rm -f /tmp/podkop-new

echo -e "${GREEN}Update complete!${NC}"
echo -e "${GREEN}Check: Services → Podkop → Diagnostics${NC}"
exit 0