#!/bin/bash

$MO_PATH $PipelineClientWorkingDir/build/StakeholderOutput.yml > $BUILDYAML_STAKEHOLDER_OUTPUT

echo "Creating stakeholder report..."

pandoc \
"$StakeholderOutputMarkdownOutputFile" \
--template $PANDOC_TEMPLATE \
--metadata-file="$BUILDYAML_STAKEHOLDER_OUTPUT" \
--from markdown \
--to=pdf \
--output $StakeholderOutputPDFOutputFile
