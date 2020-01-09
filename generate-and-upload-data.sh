#!/bin/bash

# The total uncompressed size in GB of the TPC-DS dataset you want to generate:
SCALE=1

# Get current directory (dsdgen needs full, not relative DIRs for the way we will use it): 
CURR_DIR=$(pwd)

# Relative path to the data generation tool:
TOOL_DIR=$CURR_DIR/tpc-ds/v2.11.0rc2/tools

# Path where generated data will be stored:
RAW_OUTPUT_DIR=$CURR_DIR/dataset/raw

# Make our output directory if it doesn't already exist: 
mkdir -p $RAW_OUTPUT_DIR

# Clear old contents from directory (only applicable if this script is being re-run):
rm -rf $RAW_OUTPUT_DIR/*

# Run command to generate our data set: 
$TOOL_DIR/dsdgen \
  -DISTRIBUTIONS $TOOL_DIR/tpcds.idx \
  -dir $RAW_OUTPUT_DIR \
  -scale $SCALE \
  -verbose Y \
  -force