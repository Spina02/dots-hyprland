#!/bin/bash

# Get location data using IP Geolocation
API_TOKEN="f5afcea8edca24"
location_data=$(curl -s "https://ipinfo.io?token=$API_TOKEN" 2>/dev/null)

# Extract city and country code (ISO 3166-1 alpha-2 code)
CITY=$(echo "$location_data" | jq -r '.city // empty')
COUNTRY=$(echo "$location_data" | jq -r '.country // empty')

# IPINFO Alternative [IP-API.COM]
# CITY=$(echo "$location_data" | jq -r '.city // empty')
# COUNTRY=$(echo "$location_data" | jq -r '.countryCode // empty')

# HARDCODE Location (facoltativo)
CITY=$(grep -oP '^\$CITY\s*=\s*\K.+' ~/.config/hypr/hyprlock.conf)
COUNTRY=$(grep -oP '^\$COUNTRY\s*=\s*\K.+' ~/.config/hypr/hyprlock.conf)

if [[ -n "$CITY" && -n "$COUNTRY" ]]; then
    # Imposta una larghezza adatta per l'output (modifica se necessario)
    export COLUMNS=60
    # Usa il parametro ?0n per mostrare solo il meteo attuale in ASCII art senza colori
    weather_info=$(curl -s "wttr.in/${CITY},${COUNTRY}?T0" 2>/dev/null)
    if [[ -n "$weather_info" ]]; then
        echo "$weather_info"
    else
        echo "Weather info unavailable for $COUNTRY, $CITY"
    fi
else
    echo "Unable to determine your location"
fi
