#!/bin/bash

secrets_manager()
{

echo "Obtaining discourse api key..."

bw logout

####################################
## Step 0: Set to use tsys server
####################################
bw config server https://pwvault.turnsys.com

####################################
## Step 1: login to bitwarden
####################################

# From: https://bitwarden.com/help/cli/#using-an-api-key

### Set apikey environment varaible

source D:/tsys/secrets/bitwarden/data/apikey-bitwarden-reachableceo

### Login to vault using apikey...

bw login --apikey $BW_CLIENTID $BW_CLIENTSECRET

### Step 1.1: unlock / save session id 

export BW_SESSION="$(bw unlock --passwordenv TSYS_BW_PASSWORD_REACHABLECEO --raw)"

### Step 2: retrive a value into an environment variable

export DISCOURSE_APIKEY="$(bw get password APIKEY-discourse)"

}

generate_dsr()
{

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
}

post_dsr()

{
echo "Posting DSR..."

#!/bin/bash

# Replace these with your Discourse instance details
DISCOURSE_URL="https://community.turnsys.com"  # e.g., https://forum.example.com
API_KEY="$DISCOURSE_APIKEY" # Your API key
API_USERNAME="reachableceo" # API username or admin account

# The category ID to post to (update to match your forum's categories)
CATEGORY_ID=61

# The title for the post (generated here; customize as needed)
TITLE="Daily Stakeholder Report - $(date +'%m-%d-%Y')"

# The content of the post
CONTENT="Please see the attached PDF for today's report."

# The file to upload (from the second argument or auto-generated based on date)
FILE_PATH="./DSR-"$(date +%m-%d-%Y)".pdf"

# Check if the file exists
if [ ! -f "$FILE_PATH" ]; then
  echo "File not found: $FILE_PATH"
  exit 1
fi

# Upload the file
echo "Uploading file..."
upload_response=$(curl -s -X POST "$DISCOURSE_URL/uploads.json" \
  -H "Content-Type: multipart/form-data" \
  -H "Api-Key: $API_KEY" \
  -H "Api-Username: $API_USERNAME" \
  -F "file=@$FILE_PATH;type=application/pdf" \
  -F "type=composer")

echo "Upload Response: $upload_response"

# Extract the short_url from the response
short_url=$(echo "$upload_response" | /mingw64/bin/jq -r '.short_url')

# Check if the short_url was returned
if [ "$short_url" == "null" ]; then
  echo "Failed to extract short_url. Response:"
  echo "$upload_response"
  exit 1
fi

echo "File uploaded successfully. Short URL: $short_url"

# Append the file link to the post content (Markdown format)
CONTENT="$CONTENT\n\n[Download the PDF]($short_url)"

# Create the new topic
echo "Creating new topic..."
post_response=$(curl -s -X POST "$DISCOURSE_URL/posts.json" \
  -H "Content-Type: application/json" \
  -H "Api-Key: $API_KEY" \
  -H "Api-Username: $API_USERNAME" \
  -d @- <<EOF
{
  "title": "$TITLE",
  "raw": "$CONTENT",
  "category": $CATEGORY_ID
}
EOF
)

echo "Post Response: $post_response"

# Check if the post creation was successful
if echo "$post_response" | grep -q '"id":'; then
  echo "Post created successfully!"
else
  echo "Failed to create post. Response:"
  echo "$post_response"
  exit 1
fi




}

#Create PDF from joplin exported markdown
generate_dsr

#Get discourse api key
secrets_manager 

#Create a new topic and upload/attach PDF to the topic
post_dsr