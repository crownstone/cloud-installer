#!/bin/bash

# Tokens generated at install.
export AGGREGATION_TOKEN=
export SANITATION_TOKEN=

# MongoDB settings.
# You can fill in username and password here if you configured those.
# For example: mongodb://user:password@127.0.0.1:27017/data_v1?authSource=admin&ssl=true&sslValidate=false
export MONGO_CRON_DB_NAME="crownstone_cron"
export MONGO_CRON_URL="mongodb://localhost:27017/"
export DATA_TABLE="users_v1"
export USER_DB_URL="mongodb://localhost:27017/users_v1"
export DATA_TABLE="data_v1"
export DATA_DB_URL="mongodb://localhost:27017/data_v1"
export FILES_TABLE="files_v1"
export FILES_DB_URL="mongodb://localhost:27017/files_v1"

# Other settings.
export HOST_NAME="localhost"
export NODE_ENV="production"
export DEADMANSSNITCH_API_KEY=""
export SNITCH_URL=""
export LOG_ENTRIES_TOKEN=""

# Dummy account to test if all servers work properly
export CROWNSTONE_USERNAME=""
export CROWNSTONE_PASSWORD=""
export VIRTUAL_CROWNSTONE_ID=""
export WEBHOOK_API_KEY=""
export HOOK_WAIT_TIME="10000"

# For Toon integration.
export TOON_CLIENT_ID="toon-id"
export TOON_CLIENT_SECRET="toon-secret"
