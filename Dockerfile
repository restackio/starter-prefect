# We're using the version 2.14.X of Prefect with Python 3.11
FROM prefecthq/prefect:2.14-python3.11

RUN mkdir -p flows
# Set environment variables
# test
# ENV PREFECT_API_URL='https://pr7gza.clao8l9.restack.it/api'
# ENV PREFECT_API_KEY='tnouhn3ebn'

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

# Add our flow code to the image
COPY flows /opt/prefect/flows
# COPY --chown=prefect:root flows/ /opt/prefect/flows

# Run our flow script when the container starts
CMD ["python", "flows/example-flow.py"]