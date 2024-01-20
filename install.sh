#!/bin/env sh

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
sudo ln -s "$dir/nginx/girl.technology.conf" /etc/nginx/sites-enabled/girl.technology
# Have to use copy, permissions too lax otherwise
sudo cp "$dir/sudoers.d/github_webhook_watcher" /etc/sudoers.d/github_webhook_watcher

install_service() {
  echo "### Installing $1..."
  cd "$dir/.."
  git clone "https://github.com/$1.git"
  cd "$1"
  ./install.sh
  echo "### $1 Done"
  cd "$dir"
}

# install_service p0lyw0lf/crossposter
install_service p0lyw0lf/girl.technology
install_service p0lyw0lf/github_webhook_watcher

# Have github_webhook_watcher use the config from this repository
ln -s "$dir/config.py" "$dir/../github_webhook_watcher/config.py"
