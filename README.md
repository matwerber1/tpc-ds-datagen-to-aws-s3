# Purpose

Generate a TPC-DS dataset of arbitrary size and upload to Amazon Redshift. 

This script splits your raw data into multiple files and then GZIPs each file before loading to Amazon S3. This speeds your upload to S3, reduces storage costs, and leads to faster import into Redshift. 

This project also provides you with the DML and DDL to create tables in your cluster and load data from S3. 

# AWS Official Alternative

AWS has already created TPC-DS datasets in 3 TB, 10 TB, 30 TB, and 100 TB sizes and made the data available in public buckets. You can easily use/import these to your cluster:

https://github.com/awslabs/amazon-redshift-utils/tree/master/src/CloudDataWarehouseBenchmark/Cloud-DWB-Derived-from-TPCDS

If you want to use a different data size, this project can help with that.

# Prerequisites

1. AWS Redshift cluster with enough storage capacity to hold your data.
2. An Amazon S3 bucket where you will upload your generated data and then from which you will load into Redshift. 

# Thanks

Thanks to @gregrahn. I used his project below to identify the changes that make this work on Mac OS: 
https://github.com/gregrahn/tpcds-kit

# Instructions

1. **For Mac users only**, run `brew install coreutils` to install `gsplit`, which we use to chunk our data files before uploading to S3.

1. Optional - while you could generate your data set and upload to Amazon S3 from a local machine, you may be able to achieve faster results using an EC2 instance in AWS. If you want, deploy an EC2 instance with sufficient EBS (or even better, instance storage) to support the size of data set you plan to generate. Note that EBS IOPS scale with the size of your EBS volume, up to 3,000 IOPS for a 1 TB drive. Therefore, you might want to deploy a 1 TB drive even if your data set is smaller than 1 TB to improve performance (if using EBS instead of an instance store). Of course, consider the trade-off between performance and cost when choosing instance types and storage capacity. 

1. Once your workstation (with sufficient storage) is ready, clone this project and navigate into it:

    ```sh
    git clone https://github.com/matwerber1/tpc-ds-datagen-to-aws-s3
    cd tpc-ds-datagen-to-aws-s3
    ```

1. Navigate to the `tpc-ds/v2.11.0rc2/tools/` directory and, if needed, edit line 42 in `makefile` for your operating system. The default is linux: 

    ```sh
    # tpc-ds/v2.11.0rc2/tools/makefile
    # OS Values: AIX, LINUX, SOLARIS, NCR, HPUX, or MACOS
    OS = LINUX 
    ```

1. Run `make` from the tools directory to compile the TPC-DS data generator for your environment. If you encounter any issues or want to learn more about using the tool, you can refer to the how-to guide at [tpc-ds/v2.11.0rc2/tools/How_To_Guide-DS-V2.0.0.docx](tpc-ds/v2.11.0rc2/tools/How_To_Guide-DS-V2.0.0.docx).

    ```sh
    (cd tpc-ds/v2.11.0rc2/tools && make)
    ```

1. Open `generate-and-upload-data.sh` and update the parameters at the top of the script as needed. The parameters you will need to change are shown below: 

    ```sh
    SCALE=1
    S3_BUCKET=s3://<YOUR_BUCKET>
    S3_USER_PREFIX=<YOUR_PREFIX>
    BUCKET_REGION=<YOUR_BUCKET_REGION>
    IAM_ROLE=<YOUR_IAM_ROLE>
    ```

1. Generate, split, compress, and upload data to S3:

    ```sh
    ./generate-and-upload-data.sh
    ```

    The command above will also generate a file named `load_tables.sql`, which contains commands you will later execute from within your Redshift cluster to import your data from S3. 

1. Connect to your Redshift cluster using the SQL client of your choice and execute the DDL commands contained within [create-table-ddl.sql](./create-table-dml.sql) to create the tables that will hold your data (one option for a free SQL client is [Aginity Pro](https://www.aginity.com/products/aginity-pro/)):

1. The script from Step 7 generated a file named `load_tables.sql` which contains SQL DML statements to COPY your table data from S3 into Redshift. Open this file, copy-paste the commands into your SQL client, and execute them to load data into your cluster from S3.

8. The script from Step 7 generated a file `'./queries/query_0.sql` which contains TPC-DS queries tailored for your data set size. You can use these sample queries to test your cluster performance, or you can write your own.