# We're using the version 2.14.X of Prefect with Python 3.11
FROM prefecthq/prefect:2.14-python3.11

# Set environment variables
# ENV PREFECT_API_URL='{YOUR_RESTACK_APP_URL}/api'
# ENV PREFECT_API_KEY='{PREFECT_API_KEY_HERE}'

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

# Add our flow code to the image
COPY flows /opt/prefect/flows

# Run our flow script when the container starts
CMD ["python", "flows/example-flow.py"]