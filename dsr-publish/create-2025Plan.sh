#!/bin/bash

INPUT_FILE="../dsr-build-temp/@DailyStakeholderReports/StrategicPlans/2025-ReachableCEO-Plan.md"
OUTPUT_FILE="../dsr-build-output/ReachableCEO2025Plan.pdf"
METADATA_FILE="2025Plan.yml"
TEMPLATE="eisvogel"

pandoc \
$INPUT_FILE \
--template $TEMPLATE \
--metadata-file=$METADATA_FILE \
--from markdown \
--to=pdf \
--output $OUTPUT_FILE
