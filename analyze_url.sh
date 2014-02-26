#!/bin/bash

if [ -z $1 ]; then
  URL="http://www.google.com"
else
  URL="$1"
fi

URL_TRIM=`echo "$URL" | sed -e 's/http[s]*:\/\///' -e 's/^\([^/]*\).*/\1/'`
DNS_TTL=`dig +nocmd "$URL_TRIM" +noall +answer | awk '{print $2}' | head -n 1`

curl \
  -o /dev/null \
  -w "\n\
> Requested URL: %{url_effective}\n\
  Request size: %{size_request}\n\
  Response code: %{http_code}\n\
  Response Headers size: %{size_header}\n\
  Response Content-Type: %{content_type}\n\
  Total downloaded bytes: %{size_download}\n\

> DNS lookup: %{time_namelookup}\n\
  DNS TTL: $DNS_TTL [$URL_TRIM]\n\

> Total time before transfer: %{time_pretransfer}\n\
  Time to connect: %{time_connect}\n\
  If SSL, then HandShake time: %{time_appconnect}\n\

> Total time to start first byte: %{time_starttransfer}\n\

> Total time to complete request: %{time_total}\n\

> Download speed: %{speed_download} bytes per second\n\n" \
  "$URL" 2>/dev/null
