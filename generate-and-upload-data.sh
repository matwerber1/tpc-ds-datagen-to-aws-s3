#!/bin/bash

# The total uncompressed size in GB of the TPC-DS dataset you want to generate:
SCALE=0.1

# Relative path to the data generation tool:
TOOL_DIR=tpc-ds/v2.11.0rc2/tools

# Path where generated data will be stored:
OUTPUT_DIR=dataset

# Make our output directory if it doesn't already exist: 
mkdir -p $OUTPUT_DIR

# Clear old contents from directory (only applicable if this script is being re-run):
rm -rf $OUTPUT_DIR/*

# Run command to generate our data set: 
$TOOL_DIR/dsdgen \
  -dir $DATA_DIR \
  -scale $SCALE \ 
  -verbose Y \
  -force