#!/bin/bash

set -euo pipefail

# Expand variables into rendered YAML files. These will be used by pandoc to format the output artifacts
$MO_PATH $PipelineClientWorkingDir/build/BuildTemplate-StakeholderOutput.yml > $BUILDYAML_STAKEHOLDER_OUTPUT

echo "Creating stakeholder report..."

pandoc \
"$StakeholderOutputMarkdownOutputFile" \
--template $PANDOC_TEMPLATE \
--metadata-file="$BUILDYAML_STAKEHOLDER_OUTPUT" \
--from markdown \
--to=pdf \
--output $StakeholderOutputPDFOutputFile
