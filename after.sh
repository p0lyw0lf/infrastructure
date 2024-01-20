#!/bin/env sh

sudo -n systemctl restart nginx
# Also need to restart the webhook watcher in case config.py was updated
../github_webhook_watcher/after.sh
