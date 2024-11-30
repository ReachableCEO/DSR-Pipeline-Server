# DailyStakeholderReport-Pipeline

## Introduction

I publish a daily stakeholder report to the TSYS Group discourse every day. Up until 11/29 I was performing the publishing step manually.
On 11/29 I automated the process. I also begin work on automated gathering of data going into the new version of the report.

These scripts help me maintain a daily report and high fidelity information in the report for my stakeholderrs.

## Scripts

### Publishing the report

Publishing the report involves three steps:

1. Exporting the markdown from Joplin (and attachments) I am currently doing this manually (but see export-joplin-note for a chatgpt take on automating it.).
2. Creating a (formatted/styled) PDF from the exported markdown/attachments. See the script: **create-dsr.sh**.
3. Uploading the PDF to discourse and creating a new topic in the appropriate category. See the script: **publish-dsr.sh**

### Data Gathering

I am trying to fully instrument my CTO/founder life. See the **data-gathering** sub directory (and README located therein) for WIP on that.