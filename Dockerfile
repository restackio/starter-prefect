# We’re using the version 2.14.X of Prefect with Python 3.11
FROM prefecthq/prefect:2.16-python3.10

RUN mkdir -p /opt/prefect/flows

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

WORKDIR /opt/prefect

COPY flows /opt/prefect/flows/

RUN mkdir /home/prefect/

RUN cp -R ./* /home/prefect/
