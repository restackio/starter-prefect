# We’re using the version 2.14.X of Prefect with Python 3.11
FROM prefecthq/prefect:2.14-python3.11

RUN mkdir -p /opt/prefect/flows

# Set environment variables
# ENV PREFECT_API_URL=‘https://prn9md.clao8l9.restack.it/api’
# ENV PREFECT_API_KEY=‘tnouhn3ebn’

WORKDIR /opt/prefect

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

# Add our flow code and entrypoint script to the image
COPY flows ./flows
COPY entrypoint.sh ./entrypoint.sh

# Change ownership of the /opt/prefect directory to user 1001 and make entrypoint.sh executable
RUN chown -R 1001:1001 /opt/prefect && \
    chmod +x ./entrypoint.sh

COPY flows /home/prefect/flows

# Run our flow script when the container starts
# CMD ["python", "flows/example-flow.py"]
# ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/opt/prefect/entrypoint.sh"]