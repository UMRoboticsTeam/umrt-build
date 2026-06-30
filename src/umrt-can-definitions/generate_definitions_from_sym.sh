#!/usr/bin/bash

SYMBOL_FILE="$1"
OUTPUT_FILE_BASENAME="$2"
OUTPUT_FOLDER="$3"
TRANSLATION_SCRIPT_PATH="$4"
DBC_OUTPUT_PATH="$5"

echo "Reading from '$SYMBOL_FILE'"

# Strip "/slot:" tags, cantools doesn't like it
sed -E "s|/slot:[0-9]+||g" < "$SYMBOL_FILE" | \
sed -E "s|IDMask=[0-9A-F]+h||g" > "$OUTPUT_FOLDER/.tmp.sym"

python3 -m cantools generate_c_source --database-name "$OUTPUT_FILE_BASENAME" -o "${OUTPUT_FOLDER}" "${OUTPUT_FOLDER}/.tmp.sym"

python3 "$TRANSLATION_SCRIPT_PATH" "${OUTPUT_FOLDER}/.tmp.sym" "${DBC_OUTPUT_PATH}"