#!/usr/bin/env python
# coding: utf-8

import os
import io
import requests
import argparse
import pandas as pd 
import pyarrow.parquet as pq
from sqlalchemy import create_engine
from time import time, sleep

def main(params):
    username = params.username
    password = params.password
    hostname = params.hostname
    port = params.port
    database_name = params.database_name
    table_name = params.table_name
    url = params.url
    csv = 'green_tripdata_2019-09.csv' # Placeholder value for the csv file
    gz = 'green_tripdata_2019-09.csv.gz' # Placeholder value for the compressed csv file

    response = requests.get(f'{url}')

    if url.endswith('.parquet'):
        if response.status_code == 200:
            parquet_file = pq.read_table(io.BytesIO(response.content))
            parquet_df = parquet_file.to_pandas()
            parquet_df.to_csv(csv, index = False)
            print('File converted successfully')
        else:
            print('Failed to download file')
    elif url.endswith('.csv.gz'):
        os.system(f'wget {url} -O {gz} && gzip -d -c {gz} > {csv}')
    else:
        os.system(f'wget {url}')

    print("Current Working Directory:", os.getcwd())
    print("Is file present?", os.path.isfile(csv))

    # Reading the first 100 rows of data
    df = pd.read_csv(csv)

    # Creating a SQLAlchemy engine object
    engine = create_engine(f'postgresql://{username}:{password}@{hostname}:{port}/{database_name}')

    # Creating a chunk object
    chunks = pd.read_csv(csv, iterator = True, chunksize = 100000)

    # Writing a dataframe to the SQL database. in this case, only the header -> as a DDL statement
    df.head(n = 0).to_sql(name = table_name, con = engine, if_exists = 'replace')

    while True:
        try: 
            chunk = next(chunks)
            t_start = time()
            chunk.lpep_pickup_datetime = pd.to_datetime(chunk.lpep_pickup_datetime)
            chunk.lpep_dropoff_datetime = pd.to_datetime(chunk.lpep_dropoff_datetime)
            chunk.to_sql(name = table_name, con = engine, if_exists = 'append')
            t_end = time()
            print('Inserted another chunk, time taken = %.3f seconds' %(t_end - t_start))
        except StopIteration:
            print('Finished ingestion into PostgreSQL database')
            break

def continuous_run():
    while True:
        print("Container is still running. You can Ctrl+C to stop.")
        sleep(60)
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'Ingest CSV data into a PostgreSQL database')

    parser.add_argument('--username', help = 'Username for PostgreSQL user')
    parser.add_argument('--password', help = 'Password for PostgreSQL user')
    parser.add_argument('--hostname', help = 'Hostname for PostgreSQL database')
    parser.add_argument('--port', help = 'Port for PostgreSQL instance')
    parser.add_argument('--database_name', help = 'Database name in PostgreSQL')
    parser.add_argument('--table_name', help = 'Table name in PostgreSQL')
    parser.add_argument('--url', help = 'URL of the CSV file')
    parser.add_argument('--parquet_url', help = 'URL of the Parquet file')

    args = parser.parse_args()

    main(args)
    continuous_run()
