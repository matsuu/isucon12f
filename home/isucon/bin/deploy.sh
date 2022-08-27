#!/bin/bash
set -e

DESTS="
133.152.6.242
133.152.6.243
133.152.6.244
133.152.6.245
"

for DEST in 133.152.6.24{2..5}; do
    echo "# ${DEST:?}"
    rsync -avn ~/webapp/go/isuconquest ${DEST:?}:~/webapp/go/isuconquest
    echo ""
done
