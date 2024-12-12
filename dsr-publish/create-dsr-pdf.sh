#!/bin/bash

TODAY_DATE=$(date +%m-%d-%Y)
INPUT_FILE="DSR-$TODAY_DATE.md"
OUTPUT_FILE="/d/tsys/@ReachableCEO/DailyStakeholderReport-Pipeline/dsr-build-output/DSR-$TODAY_DATE.pdf"
METADATA_FILE="/d/tsys/@ReachableCEO/DailyStakeholderReport-Pipeline/dsr-publish/daily-stakeholder-report.yml"
TEMPLATE="eisvogel"

cd /d/tsys/@ReachableCEO/DailyStakeholderReport-Pipeline/dsr-build-temp/@DailyStakeholderReports/Today || exit

pandoc \
$INPUT_FILE \
--template $TEMPLATE \
--metadata-file=$METADATA_FILE \
--from markdown \
--to=pdf \
--output $OUTPUT_FILE
