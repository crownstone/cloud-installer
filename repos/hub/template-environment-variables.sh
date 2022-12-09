#!/bin/bash --login

# Tokens generated at install.
AGGREGATION_TOKEN=
SANITATION_TOKEN=
SSE_TOKEN=

# By default, every USB device is tried to see if that's a crownstone dongle.
#
# Instead, a fixed device can be used, for example:
# CS_HUB_UART_PORT="/dev/ttyUSB0"
# CS_HUB_UART_PORT="/dev/serial/by-id/usb-Silicon_Labs_CP2104_USB_to_UART_Bridge_Controller_014A641C-if00-port0"
#
# Or a search pattern can be used:
# CS_UART_SEARCH_BY_ID: "true"
# CS_UART_SEARCH_BY_ID_PATH: "/dev/serial/by-id"
# CS_UART_SEARCH_BY_ID_PATTERN: "(usb-Silicon_Labs_CP2104_USB_to_UART_Bridge_Controller_.*|.*Crownstone_dongle.*)"

# Where the config is written.
CS_HUB_CONFIG_PATH=""

# Where the openssl-hub.conf is found. Defaults to ./config
CS_HUB_SLL_CONFIG_PATH=""

# Where the https cert.pem and key.pem files are written to. Defaults to ./config/https
CS_HUB_HTTPS_CERTIFICATE_PATH=""

# Log settings
CS_ENABLE_FILE_LOGGING="false"
CS_FILE_LOGGING_DIRNAME="logs"
CS_FILE_LOGGING_LEVEL="info"
CS_CONSOLE_LOGGING_LEVEL="none"
DEBUG=""
DEBUG_HIDE_DATE="false"
DEBUG_LEVEL="INFO"
DEBUG_JSON="false"

# Ports at which this server is available.
# http port
HTTP_PORT="3200"
# https port
PORT="3201"