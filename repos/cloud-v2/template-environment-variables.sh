#!/bin/bash

# Tokens generated at install.
export AGGREGATION_TOKEN=
export SANITATION_TOKEN=
export SSE_TOKEN=

# Port at which this server is available.
export PORT="3050"

# MongoDB settings.
# You can fill in username and password here if you configured those.
# For example: mongodb://user:password@127.0.0.1:27017/data_v1?authSource=admin&ssl=true&sslValidate=false
export USER_DB_URL="mongodb://localhost:27017/users_v1"
export DATA_DB_URL="mongodb://localhost:27017/data_v1"
export FILES_DB_URL="mongodb://localhost:27017/files_v1"

# Other settings.
export EMAIL_VALIDATION_REQUIRED="false"
export ALLOW_IMPORT="YES"
