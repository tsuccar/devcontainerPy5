# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
# there is "remoteUser":"vscode" in devcontainer.json to log into container
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

WORKDIR /workspace

# install os dependencies
RUN apt-get update && apt-get install -y python3 python3-pip
# Upgrade pip
RUN pip install --upgrade pip
# Werkzeug is a dependency but upgrades all the way to 3.0 & not compatible yet
# And installing it here to show other ways than requirements.txt
RUN pip install flask==2.1.* Werkzeug==2.2.2 
# The following uid & guid creation required that it comes after apt-get & pip install 
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME
## Make sure to reflect new user in PATH
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"
USER $USERNAME  

# app modules dependencies in requirements
# Install production dependencies
# COPY --chown=nonroot:1000 requirements.txt /tmp/requirements.txt
# RUN pip install -r /tmp/requirements.txt && \
#     rm /tmp/requirements.txt
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
# Install development dependencies
# COPY --chown=nonroot:1000 requirements-dev.txt /tmp/requirements-dev.txt
# RUN pip install -r /tmp/requirements-dev.txt && \
#     rm /tmp/requirements-dev.txt
COPY requirements-dev.txt ./
RUN pip install --no-cache-dir -r requirements-dev.txt

# install app, remember target "." is relative to /workspace, along with CMD
COPY ./src/hello.py .

# final configuration
EXPOSE 5002
ENV FLASK_APP=hello
# CMD flask run --host 0.0.0.0 --port 5002 //run it here or in docker-compose.yml
#