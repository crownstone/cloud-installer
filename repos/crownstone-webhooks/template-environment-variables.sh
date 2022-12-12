#!/bin/bash

# Tokens generated at install.
export CROWNSTONE_CLOUD_SSE_TOKEN=
export CROWNSTONE_USER_ADMIN_KEY=
export DEBUG_TOKEN=

# Default settings.
export DEBUG=""
export DEBUG_LEVEL="INFO"
export HOST="localhost"

# Port at which this server is available.
export PORT="3100"

# MongoDB settings
export MONGO_DB="crownstone_webhooks"
export MONGO_URL="mongodb://localhost:27017/"

# Number of calls allowed per day for each listener.
export DAILY_ALLOWANCE="5000"

# Used only for a log.
export BASE_URL="localhost"

# The endpoint for cloud v1, should match its settings.
export CROWNSTONE_CLOUD_SOCKET_ENDPOINT="http://127.0.0.1:3000"

# The endpoint for cloud v2, should match its settings.
export CROWNSTONE_CLOUD_NEXT_SOCKET_ENDPOINT="http://127.0.0.1:3050"
