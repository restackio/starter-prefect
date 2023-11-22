# We’re using the version 2.14.X of Prefect with Python 3.11
FROM prefecthq/prefect:2.14-python3.11

RUN mkdir -p /opt/prefect/flows

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

WORKDIR /opt/prefect

# Add our flows' code and entrypoint script to the image
COPY flows ./flows
COPY entrypoint.sh ./entrypoint.sh

# Change ownership of the /opt/prefect directory to user 1001 and make entrypoint.sh executable
RUN chown -R 1001:1001 /opt/prefect && \
    chmod +x ./entrypoint.sh