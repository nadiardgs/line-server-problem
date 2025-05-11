#!/bin/bash

# Data directory should exist, but this line is added to guarantee it
mkdir -p data

# Path to the input file
INPUT_FILE="input.txt"
OUTPUT_FILE="line_offsets.dat"

# Check if the index file already exists and if the input file is newer
if [ -f "$OUTPUT_FILE" ] && [ "$INPUT_FILE" -nt "$OUTPUT_FILE" ]; then
  echo "Input file '$INPUT_FILE' has been modified since the index was created."
  echo "Re-generating line offset index..."
  bundle exec rails runner "PreprocessFile.generate_index('$INPUT_FILE', '$OUTPUT_FILE')"
elif [ ! -f "$OUTPUT_FILE" ]; then
  echo "Index file '$OUTPUT_FILE' not found."
  echo "Generating line offset index..."
  bundle exec rails runner "PreprocessFile.generate_index('$INPUT_FILE', '$OUTPUT_FILE')"
else
  echo "Line offset index '$OUTPUT_FILE' is up to date."
fi

echo "Build process complete."
