#!/bin/sh
set -e

## Variables needed to run `migrate up`
export DB_USER=`cat /run/secrets/DB_USER`
export DB_PASSWORD=`cat /run/secrets/DB_PASSWORD`

bash box