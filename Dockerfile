# Using Prefect version 2.14.X with Python 3.11
FROM prefecthq/prefect:2.14-python3.11
# Set the working directory to /opt/prefect
WORKDIR /opt/prefect
# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir
# Create and set the working directory to /home/prefect
RUN mkdir -p /home/prefect
WORKDIR /home/prefect
# Change ownership of the /home/prefect directory
RUN chown -R 1001:1001 /home/prefect
# Copy the flows directory
COPY flows ./flows
# (Optional) Set environment variables
# ENV PREFECT_API_URL=‘https://prn9md.clao8l9.restack.it/api’
# ENV PREFECT_API_KEY=‘tnouhn3ebn’
# Copy the entrypoint script
COPY entrypoint.sh /opt/prefect/entrypoint.sh
# Change ownership of the /opt/prefect directory and make entrypoint.sh executable
RUN chown -R 1001:1001 /opt/prefect && \
    chmod +x /opt/prefect/entrypoint.sh
# Uncomment to run your flow script when the container starts
# CMD [“python”, “flows/example-flow.py”]
# ENTRYPOINT [“/usr/bin/tini”, “-g”, “--“, “/opt/prefect/entrypoint.sh”]





