FROM python:3.9

WORKDIR /docker_sql

COPY ingest_data.py ingest_data.py

RUN pip install pandas sqlalchemy psycopg2 pyarrow requests

ENTRYPOINT [ "python3", "ingest_data.py" ]