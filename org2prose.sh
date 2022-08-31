#!/bin/bash

# This script comes with ABSOLUTELY NO WARRANTY, use at own risk
# Copyright (C) 2018 Osiris Alejandro Gomez <osiris@gcoop.coop>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# shellcheck disable=SC2129

[[ -z "$1" ]] && exit 1
[[ -e "$1" ]] || exit 1

ORG="$1"
NAME="$(basename "$ORG" .org)"
MD="${NAME}.md"
BAK="${NAME}.bak"
ORG="${NAME}.org"
HTM="${NAME}.html"

[[ -z "$2"  ]] || MD="$2"
[[ -e "$MD" ]] && mv -f "$MD" "$BAK"

TITLE="$(org-title   "$ORG" | tr -d ':')"
DATE="$(org-date     "$ORG" | tr -d ':')"
AUTHOR="$(org-author "$ORG" | tr -d ':')"
EMAIL="$(org-email   "$ORG" | tr -d ':')"

H='---'

printf "%s\ntitle: %s\ndate: %s\nauthor: %s %s\n%s\n\n" \
       "$H" "$TITLE" "$DATE" "$AUTHOR" "$EMAIL" "$H"    > "$MD"

# FIXME use a config file to define variables
[[ -n "$GIT" ]] || GIT='https://gitlab.com/osiux/osiux.gitlab.io/-/raw/master'
[[ -n "$OSI" ]] || OSI='https://osiux.gitlab.io'
[[ -n "$GMI" ]] || GMI='gemini://gmi.osiux.com'

printf "[\`.%s\`](%s/%s) |\n" 'org'  "$GIT" "$ORG" >> "$MD"
printf "[\`.%s\`](%s/%s) |\n" 'md'   "$GIT" "$MD"  >> "$MD"
printf "[\`.%s\`](%s/%s) |\n" 'gmi'  "$GMI" "${ORG//\.org/.gmi}" >> "$MD"
printf "[\`.%s\`](%s/%s)\n\n" 'html' "$OSI" "$HTM" >> "$MD"

pandoc -f org -t markdown "$ORG" --atx-headers >> "$MD" && echo "$MD"

# FIXME find a better way to replace image links
sed -i 's/file:img/https:\/\/osiux.com\/img/g' "$MD"
sed -i 's/tmb\//https:\/\/osiux.com\/tmb\//g'  "$MD"
sed -i 's/icn\//https:\/\/osiux.com\/icn\//g'  "$MD"

TMP="$(mktemp)"

while read -r LINE
do
  if [[ "$LINE" =~ https ]]
  then
    echo "$LINE"
  else
    echo "$LINE" | sed -re 's/.org[)]/)/g'
  fi
done < "$MD" > "$TMP"

mv -f "$TMP" "$MD"
