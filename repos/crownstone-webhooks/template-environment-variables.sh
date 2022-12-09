#!/bin/bash --login

# Tokens generated at install.
CROWNSTONE_CLOUD_SSE_TOKEN=
CROWNSTONE_USER_ADMIN_KEY=
DEBUG_TOKEN=

# Default settings.
DEBUG=""
DEBUG_LEVEL="INFO"
HOST="localhost"

# Port at which this server is available.
PORT="3100"

# MongoDB settings
MONGO_DB="crownstone_webhooks"
MONGO_URL="mongodb://localhost:27017/"

# Number of calls allowed per day for each listener.
DAILY_ALLOWANCE="5000"

# Used only for a log.
BASE_URL="localhost"

# The endpoint for cloud v1, should match its settings.
CROWNSTONE_CLOUD_SOCKET_ENDPOINT="http://127.0.0.1:3000"

# The endpoint for cloud v2, should match its settings.
CROWNSTONE_CLOUD_NEXT_SOCKET_ENDPOINT="http://127.0.0.1:3050"
