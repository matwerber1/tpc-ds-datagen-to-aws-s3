#!/bin/bash

# The total uncompressed size in GB of the TPC-DS dataset you want to generate:
SCALE=1

# Amazon S3 output bucket to store results: 
S3_BUCKET=s3://werberm-sandbox

# Amazon S3 prefix to store results: 
S3_USER_PREFIX=bigdata/tpc-ds

S3_FULL_PATH=$S3_BUCKET/$S3_USER_PREFIX/${SCALE}gb

# Get current directory (dsdgen needs full, not relative DIRs for the way we will use it): 
CURR_DIR=$(pwd)

# Relative path to the data generation tool:
TOOL_DIR=$CURR_DIR/tpc-ds/v2.11.0rc2/tools

# Path where generated data will be stored:
RAW_OUTPUT_DIR=$CURR_DIR/dataset/raw

# Make our output directory if it doesn't already exist: 
mkdir -p $RAW_OUTPUT_DIR

# Run command to generate our data set: 
#$TOOL_DIR/dsdgen \
#  -DISTRIBUTIONS $TOOL_DIR/tpcds.idx \
#  -dir $RAW_OUTPUT_DIR \
#  -scale $SCALE \
#  -verbose Y \
#  -force

# Number of megabytes per file when splitting the raw TPC-DS source files into smaller chunks:
MEGABYTES_PER_RAW_FILE="50M"

GZIP_OUTPUT_PREFIX=dataset/s3

# Split each raw file into multiple GZIP'd files and upload to Amazon S3
for RAW_FILE_PATH in $RAW_OUTPUT_DIR/*
do
  # Get filename only (strip path):
  FILENAME_EXT=$(basename "$RAW_FILE_PATH")
  
  # Get filename without extension (we will use this as part of our folder name prefix in S3):
  FILENAME=$(echo "$FILENAME_EXT" | cut -f 1 -d '.')
  echo "Processing $FILENAME..."
  
  # Directory to store our GZIP'd results: 
  GZIP_OUTPUT_DIR=$GZIP_OUTPUT_PREFIX/$FILENAME/
  
  # Make the directory if it doesn't already exist:
  mkdir -p $GZIP_OUTPUT_DIR
  
  # Split our file into chunks, and process each chunk with GZIP
  #split -C $MEGABYTES_PER_RAW_FILE --filter='gzip > $FILE.gz' $RAW_FILE_PATH $GZIP_OUTPUT_DIR

  # Copy GZIP'd files to S3 path, which each table's files in its own prefix matching the table/filename: 
  aws s3 sync $GZIP_OUTPUT_DIR $S3_FULL_PATH/$FILENAME/

done