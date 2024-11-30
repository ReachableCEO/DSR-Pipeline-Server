#!/bin/bash

echo "Creating PDF of DSR from markdown input via pandoc..."

INPUT_FILE="./DSR-$(date +%m-%d-%Y).md"
OUTPUT_FILE="./DSR-$(date +%m-%d-%Y).pdf"
METADATA_FILE="daily-stakeholder-report.yml"
TEMPLATE="eisvogel"

pandoc \
$INPUT_FILE \
--template $TEMPLATE \
--metadata-file=$METADATA_FILE \
--from markdown \
--to=pdf \
--output $OUTPUT_FILE