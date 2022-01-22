
import os
import argparse

from time import time

import pandas as pd
from sqlalchemy import create_engine


def main(params):
    user = params.user
    password = params.password
    host = params.host 
    port = params.port 
    db = params.db
    table_name = params.table_name
    url = params.url
    csv_name = 'output.csv'

    #downloading source file
    os.system(f"wget {url} -O {csv_name}")

    #instantiating connection
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    #reading downloaded file
    df = pd.read_csv(csv_name)

    #changing datatype to dates for some columns
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

    #creating table
    df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')

    #chunking big dataframe
    n = 100000
    chunks = [df[i:i+n] for i in range(0,df.shape[0],n)]

    #ingesting into database
    for chunk in chunks:
        t_start = time()
        chunk.to_sql(name=table_name, con=engine, if_exists='append')
        t_end = time()
        print('inserted another chunk, took %.3f second' % (t_end - t_start))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--user', help='user name for postgres')
    parser.add_argument('--password', help='password for postgres')
    parser.add_argument('--host', help='host for postgres')
    parser.add_argument('--port', help='port for postgres')
    parser.add_argument('--db', help='database name for postgres')
    parser.add_argument('--table_name', help='name of the table where we will write the results to')
    parser.add_argument('--url', help='url of the csv file')

    args = parser.parse_args()

    main(args)