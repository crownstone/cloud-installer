#!/bin/bash --login

# Tokens generated at install.
AGGREGATION_TOKEN=
SANITATION_TOKEN=
CROWNSTONE_CLOUD_SSE_TOKEN=
SESSION_SECRET=
DEBUG_TOKEN=

# Port at which this server is available.
PORT="3000"

# Other settings.
EMAIL_VALIDATION_REQUIRED="false"
NODE_ENV="production"
NOTIFICATION_TYPE="release"
DEBUG=""
STRONGLOOP_CLUSTER="2"

# MongoDB settings.
# The URLs are prefixed with: mongodb://
# You can fill in username and password here if you configured those.
# For example: user:password@127.0.0.1:27017/data_v1?authSource=admin&ssl=true&sslValidate=false
DATA_TABLE="users_v1"
USER_DB_URL="localhost:27017/users_v1"
DATA_TABLE="data_v1"
DATA_DB_URL="localhost:27017/data_v1"
FILES_TABLE="files_v1"
FILES_DB_URL="localhost:27017/files_v1"

# Config variables for email validation, when enabled these should be filled in.
BASE_URL="localhost"
MAIL_USER="my@email.address"
MAIL_PASSWORD="password"
MAIL_PROVIDER="gmail"

# For Toon integration.
TOON_CLIENT_ID="toon-id"
TOON_CLIENT_SECRET="toon-secret"
