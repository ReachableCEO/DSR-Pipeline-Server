#!/bin/bash

TODAY_DATE=$(date +%m-%d-%Y)
INPUT_FILE="../dsr-build-temp/@DailyStakeholderReports/Today/DSR-$TODAY_DATE.md"
OUTPUT_FILE="../dsr-build-output/DSR-$TODAY_DATE.pdf"
METADATA_FILE="daily-stakeholder-report.yml"
TEMPLATE="eisvogel"

pandoc \
$INPUT_FILE \
--template $TEMPLATE \
--metadata-file=$METADATA_FILE \
--from markdown \
--to=pdf \
--output $OUTPUT_FILE
