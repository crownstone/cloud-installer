#!/bin/bash --login

# Tokens generated at install.
AGGREGATION_TOKEN=
SANITATION_TOKEN=
SSE_TOKEN=

# Port at which this server is available.
PORT="3050"

# MongoDB settings.
# You can fill in username and password here if you configured those.
# For example: mongodb://user:password@127.0.0.1:27017/data_v1?authSource=admin&ssl=true&sslValidate=false
USER_DB_URL="mongodb://localhost:27017/users_v1"
DATA_DB_URL="mongodb://localhost:27017/data_v1"
FILES_DB_URL="mongodb://localhost:27017/files_v1"

# Other settings.
EMAIL_VALIDATION_REQUIRED="false"
