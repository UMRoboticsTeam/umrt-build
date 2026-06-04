#!/usr/bin/bash

SYMBOL_FILE="$1"
OUTPUT_FILE_BASENAME="$2"
OUTPUT_FOLDER="$3"

# Strip "/slot:" tags, cantools doesn't like it
sed -E "s|/slot:[0-9]+||g" < "$SYMBOL_FILE" | \
sed -E "s|IDMask=[0-9A-F]+h||g" > "$OUTPUT_FOLDER/.tmp.sym"

python3 -m cantools generate_c_source --database-name "$OUTPUT_FILE_BASENAME" -o "${OUTPUT_FOLDER}" "${OUTPUT_FOLDER}/.tmp.sym"