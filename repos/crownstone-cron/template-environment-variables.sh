#!/bin/bash --login

# Tokens generated at install.
AGGREGATION_TOKEN=
SANITATION_TOKEN=

# MongoDB settings.
# You can fill in username and password here if you configured those.
# For example: mongodb://user:password@127.0.0.1:27017/data_v1?authSource=admin&ssl=true&sslValidate=false
MONGO_CRON_DB_NAME="crownstone_cron"
MONGO_CRON_URL="mongodb://localhost:27017/"
DATA_TABLE="users_v1"
USER_DB_URL="mongodb://localhost:27017/users_v1"
DATA_TABLE="data_v1"
DATA_DB_URL="mongodb://localhost:27017/data_v1"
FILES_TABLE="files_v1"
FILES_DB_URL="mongodb://localhost:27017/files_v1"

# Other settings.
HOST_NAME="localhost"
NODE_ENV="production"
DEADMANSSNITCH_API_KEY=""
SNITCH_URL=""
LOG_ENTRIES_TOKEN=""

# Dummy account to test if all servers work properly
CROWNSTONE_USERNAME=""
CROWNSTONE_PASSWORD=""
VIRTUAL_CROWNSTONE_ID=""
WEBHOOK_API_KEY=""
HOOK_WAIT_TIME="10000"

# For Toon integration.
TOON_CLIENT_ID="toon-id"
TOON_CLIENT_SECRET="toon-secret"
