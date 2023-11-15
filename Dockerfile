# We're using the version 2.14.X of Prefect with Python 3.11
FROM prefecthq/prefect:2.14-python3.11

RUN mkdir -p flows
# Set environment variables
# test
# ENV PREFECT_API_URL='https://prabng.clao8l9.restack.it/api'
# ENV PREFECT_API_KEY='tnouhn3ebn'

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

# Add our flow code to the image
COPY flows /opt/prefect/flows
# COPY --chown=79cebfcf-6a1f-483c-bf98-1235a23c9b5d:root flows/ /opt/prefect/flows

# Run our flow script when the container starts
CMD ["python", "/opt/prefect/flows/example-flow.py"]