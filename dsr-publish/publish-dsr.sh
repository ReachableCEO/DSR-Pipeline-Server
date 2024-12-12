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

post_dsr()

{

TODAY_DATE=$(date +%m-%d-%Y)

echo "Posting DSR..."

DISCOURSE_URL="https://community.turnsys.com"  # e.g., https://forum.example.com
API_KEY="$DISCOURSE_APIKEY" # Your API key
API_USERNAME="reachableceo" # API username or admin account

# The category ID to post to (update to match your forum's categories)
CATEGORY_ID=61

# The title for the post (generated here; customize as needed)
TITLE="Daily Stakeholder Report - $TODAY_DATE"

# The content of the post
CONTENT="Please use the link below to download today's stakeholder report."

# The file to upload (from the second argument or auto-generated based on date)
FILE_PATH="../dsr-build-output/DSR-$TODAY_DATE.pdf"

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
CONTENT="$CONTENT\n\n[Download todays report in PDF format]($short_url)"

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

#Get discourse api key

secrets_manager 

# - Create a new topic 
# - upload PDF to discourse
# - attach uploaded PDF to the topic

post_dsr
