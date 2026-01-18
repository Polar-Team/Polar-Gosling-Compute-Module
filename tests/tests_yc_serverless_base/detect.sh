#!/bin/bash -e
[ -d /mnt/c ] && echo '{"os": "Windows"}' || echo '{"os": "Linux"}'
