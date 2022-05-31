#! /bin/bash

# The primary purpose of this script is to give an easy way to refresh the 
# access tokens and to run a keep alive so the end point doesn't go stale
# and stop giving access to the service (silently) thus causing the 
# door bell to no ring.

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$dir/config.env"

open_auth_site() {
    open "https://nestservices.google.com/partnerconnections/${project_id}/auth?redirect_uri=https://www.google.com&access_type=offline&prompt=consent&client_id=${oauth2_client_id}&response_type=code&scope=https://www.googleapis.com/auth/sdm.service"
}

fetch_tokens() {
    response=`curl -s -L -X POST "https://www.googleapis.com/oauth2/v4/token?client_id=${oauth2_client_id}&client_secret=${oauth2_client_secret}&code=${authorization_code}&grant_type=authorization_code&redirect_uri=https://www.google.com"`

    has_error=`echo $response | jq -r 'has("error")'`
    if `$has_error` ; then
        echo "Request Error: $response"
        return
    fi

    access_token=`echo $response | jq -r '.access_token'`
    refresh_token=`echo $response | jq -r '.refresh_token'`

    echo "Access Token: $access_token"
    echo "Refresh Token: $refresh_token"
}

list_devices() {
    refresh_token

    curl -X GET "https://smartdevicemanagement.googleapis.com/v1/enterprises/${project_id}/devices" \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer ${access_token}"
}

refresh_token() {
    response=`curl -s -L -X POST "https://www.googleapis.com/oauth2/v4/token?client_id=${oauth2_client_id}&client_secret=${oauth2_client_secret}&refresh_token=${refresh_token}&grant_type=refresh_token"`

    has_error=`echo $response | jq -r 'has("error")'`
    if `$has_error` ; then
        echo "Request Error: $response"
        return
    fi

    access_token=`echo $response | jq -r '.access_token'`
    echo "New Access Token: $access_token"
}

case "$1" in
	authorize)
		open_auth_site
		;;

    tokens)
        fetch_tokens
        ;;

    devices)
        list_devices
        ;;

    refresh)
        refresh_token
        ;;

    refresh-loop)
        while true
        do
            refresh_token
            refresh_seconds=1800 # 30 minutes
            sleep $refresh_seconds
        done
        ;;
esac
