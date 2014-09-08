#! /bin/sh

eval "local thing=\${$1:-}"
if [ ! -z "${thing:-}" ]; then
    exit 0
fi
exit 1
