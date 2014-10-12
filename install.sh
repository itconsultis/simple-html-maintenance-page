#!/usr/bin/env bash

TEMP_FILE=$(mktemp /tmp/maintenance_index.html.XXXXX)

curl -sSL https://raw.githubusercontent.com/hamidnazari/maintenance/master/index.html > $TEMP_FILE

echo -n "Name (optional): " 1>&2
read NAME

echo -n "Email (optional): " 1>&2
read EMAIL

if [ -z "$NAME" ] && [ -n "$EMAIL" ]; then
    NAME=$EMAIL
fi

sed -i.bak -E "s/\[Name\]/$NAME/g" $TEMP_FILE

if [ -n "$NAME" ] && [ -n "$EMAIL" ]; then
    sed -i.bak -E "s/\[Email\]/$EMAIL/g" $TEMP_FILE
elif [ -n "$NAME" ] && [ -z "$EMAIL" ]; then
    sed -i.bak -E "s/<a.*>(.*)<\/a>/\1/g" $TEMP_FILE
elif [ -z "$NAME" ] && [ -z "$EMAIL" ]; then
    sed -i.bak -E "s/<p.*id=\"signature\".*>.*<\/p>//g" $TEMP_FILE
fi

cat $TEMP_FILE
rm -f $TEMP_FILE*
