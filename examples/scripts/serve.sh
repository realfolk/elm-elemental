#! /usr/bin/env bash

port="$1"
npx serve@13 --single --cors --no-clipboard "public" -l "$port"
