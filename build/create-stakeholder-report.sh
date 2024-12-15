#!/bin/bash

$MO_PATH $PipelineClientWorkingDir/build/stakeholder-report.yml > $BUILDYAML_STAKEHOLDER_REPORT

echo "Creating stakeholder report..."

pandoc \
"$StakeholderReportMarkdownOutputFile" \
--template $PANDOC_TEMPLATE \
--metadata-file="$BUILDYAML_STAKEHOLDER_REPORT" \
--from markdown \
--to=pdf \
--output $StakeholderReportPDFOutputFile