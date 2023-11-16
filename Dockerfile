# We’re using the version 2.14.X of Prefect with Python 3.11
FROM prefecthq/prefect:2.14-python3.11

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

WORKDIR /home/prefect

RUN chown -R 1001:1001 /home/prefect

RUN mkdir -p /home/prefect/flows

# Set environment variables
# ENV PREFECT_API_URL=‘https://prn9md.clao8l9.restack.it/api’
# ENV PREFECT_API_KEY=‘tnouhn3ebn’

# Add our flow code and entrypoint script to the image
COPY flows ./flows


WORKDIR /opt/prefect


COPY entrypoint.sh ./entrypoint.sh

# Change ownership of the /opt/prefect directory to user 1001 and make entrypoint.sh executable
RUN chown -R 1001:1001 /opt/prefect && \
    chmod +x ./entrypoint.sh

# Run our flow script when the container starts
# CMD ["python", "flows/example-flow.py"]
# ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/opt/prefect/entrypoint.sh"]