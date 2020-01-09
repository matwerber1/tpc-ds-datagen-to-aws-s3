# Instructions

1. Optional - while you could generate your data set and upload to Amazon S3 from a local machine, you may be able to achieve faster results using an EC2 instance in AWS. If you want, deploy an EC2 instance with sufficient EBS (or even better, instance storage) to support the size of data set you plan to generate. Note that EBS IOPS scale with the size of your EBS volume, up to 3,000 IOPS for a 1 TB drive. Therefore, you might want to deploy a 1 TB drive even if your data set is smaller than 1 TB to improve performance (if using EBS instead of an instance store). Of course, consider the trade-off between performance and cost when choosing instance types and storage capacity. 

2. Once your workstation (with sufficient storage) is ready, clone this project and navigate into it:

    ```sh
    git clone https://github.com/matwerber1/tpc-ds-datagen-to-aws-s3
    cd tpc-ds-datagen-to-aws-s3
    ```

3. Navigate to the `tpc-ds/v2.11.0rc2/tools/` directory and, if needed, edit line 42 in `makefile` for your operating system. The default is linux: 

    ```sh
    # tpc-ds/v2.11.0rc2/tools/makefile
    # OS Values: AIX, LINUX, SOLARIS, NCR, HPUX
    OS = LINUX 
    ```

3. Run `make` from the tools directory to compile the TPC-DS data generator for your environment. If you encounter any issues or want to learn more about using the tool, you can refer to the how-to guide at [tpc-ds/v2.11.0rc2/tools/How_To_Guide-DS-V2.0.0.docx](tpc-ds/v2.11.0rc2/tools/How_To_Guide-DS-V2.0.0.docx).

    ```sh
    (cd tpc-ds/v2.11.0rc2/tools && make)
    ```

4. Open `generate-and-upload-data.sh` and update the parameters at the top of the script as needed. The parameters you will need to change are shown below: 

    ```sh
    SCALE=1
    S3_BUCKET=s3://<YOUR_BUCKET>
    S3_USER_PREFIX=<YOUR_PREFIX>
    IAM_ROLE=<YOUR_IAM_ROLE>
    ```

5. Generate, split, compress, and upload data to S3:

    ```sh
    ./generate-and-upload-data.sh
    ```

    The command above will also generate a file named `load_tables.sql`, which contains commands you will later execute from within your Redshift cluster to import your data from S3. 

6. Connect to your Redshift cluster using the SQL client of your choice and execute the DDL commands contained within [create-table-ddl.sql](./create-table-dml.sql) to create the tables that will hold your data (one option for a free SQL client is [Aginity Pro](https://www.aginity.com/products/aginity-pro/)):

7. The script from Step 5 generated a file named `load_tables.sql` which contains SQL DML statements to COPY your table data from S3 into Redshift. Open this file, copy-paste the commands into your SQL client, and execute them to load data into your cluster from S3.

8. TODO: Add steps to generate and run queries to test the data set and Redshift performance. 