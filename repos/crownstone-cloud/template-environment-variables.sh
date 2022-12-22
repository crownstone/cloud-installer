#!/bin/bash

# Tokens generated at install.
export AGGREGATION_TOKEN=
export SANITATION_TOKEN=
export CROWNSTONE_CLOUD_SSE_TOKEN=
export SESSION_SECRET=
export DEBUG_TOKEN=

# Port at which this server is available.
export PORT="3000"

# Other settings.
export EMAIL_VALIDATION_REQUIRED="false"
export NODE_ENV="production"
export NOTIFICATION_TYPE="release"
export DEBUG=""
export STRONGLOOP_CLUSTER="2"

# MongoDB settings.
# The URLs are prefixed with: mongodb://
# You can fill in username and password here if you configured those.
# For example: user:password@127.0.0.1:27017/data_v1?authSource=admin&ssl=true&sslValidate=false
export DATA_TABLE="users_v1"
export USER_DB_URL="localhost:27017/users_v1"
export DATA_TABLE="data_v1"
export DATA_DB_URL="localhost:27017/data_v1"
export FILES_TABLE="files_v1"
export FILES_DB_URL="localhost:27017/files_v1"

# Config variables for email validation, when enabled these should be filled in.
export BASE_URL="localhost"
export MAIL_USER="my@email.address"
export MAIL_PASSWORD="password"
export MAIL_PROVIDER="gmail"

# For Toon integration.
export TOON_CLIENT_ID="toon-id"
export TOON_CLIENT_SECRET="toon-secret"
