#!/bin/bash

# Check if a filename argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# Set an environment variable for the filename
export TEXT_FILE_TO_SERVE="$1"

echo "Starting Rails server to serve file: $TEXT_FILE_TO_SERVE"
bundle exec rails server