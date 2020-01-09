#!/bin/bash

########################
# UPDATE THESE VARIABLES
########################
# The total uncompressed size in GB of the TPC-DS dataset you want to generate:
SCALE=1

# Amazon S3 output bucket to store results: 
S3_BUCKET=s3://werberm-sandbox

# Amazon S3 prefix to store results: 
S3_USER_PREFIX=bigdata/tpc-ds

# The full ARN of the IAM role that grants your Redshift cluster 
# permission to read data from the S3 bucket/path you specified above:
IAM_ROLE=arn:aws:iam::111111111111:role/RedshiftClusterRole

####################################################################
# DO NOT EDIT BELOW THIS LINE (UNLESS YOU WANT TO FURTHER CUSTOMIZE
####################################################################
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

# Number of megabytes per file when splitting the raw TPC-DS source files into smaller chunks.
# I chose 20M because, when compressed, this should typically give files > 1 MB (which is best practice), 
# while still generating lots of files (on larger data sets) so we can parallelize the load into Redshift
MEGABYTES_PER_RAW_FILE="20M"

GZIP_OUTPUT_PREFIX=dataset/s3

"" > load_tables.sql

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

  # Our table name should match our filename; the variable below just makes this script more readable:
  TABLE=$FILENAME

  # Generate the SQL to load our data from S3 to Redshift.
  SQL="copy $TABLE from '$S3_FULL_PATH/$FILENAME/' iam_role '$IAM_ROLE' gzip delimiter '|' COMPUPDATE ON region 'us-east-1';"

  # Write SQL to our sql script: 
  echo $SQL >> load_tables.sql

done