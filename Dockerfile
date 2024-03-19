# We’re using the version 2.14.X of Prefect with Python 3.11
FROM prefecthq/prefect:2.16-python3.10

RUN mkdir -p /opt/prefect/flows

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

WORKDIR /opt/prefect

COPY --chown=prefect:root dbt_project /opt/prefect/dbt_project/
COPY --chown=prefect:root flows /opt/prefect/flows/

RUN mkdir /home/prefect/

RUN cp -R ./* /home/prefect/

RUN cd /opt/prefect/dbt_project && dbt deps

RUN cd /opt/prefect


#RUN python ./flows/main.py && python ./flows/dbt_flow.py

# TODO: Should we keep this entrypoint file?

# Add our flows' code and entrypoint script to the image
#COPY entrypoint.sh /home/prefect/entrypoint.sh

#RUN chmod +x ./entrypoint.sh

# Change ownership of the /opt/prefect directory to user 1001 and make entrypoint.sh executable
#RUN chown -R 1001:1001 /opt/prefect && \
#    chmod +x ./entrypoint.sh
