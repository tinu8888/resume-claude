#!/usr/bin/env bash
# One command to install everything this workspace needs.
# macOS (Homebrew) and Debian/Ubuntu (apt) are handled automatically.
# Safe to run more than once: it skips anything already installed.

set -e

echo "Installing requirements for the resume workspace..."
echo

OS="$(uname -s)"

install_mac() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing it first..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if command -v xelatex >/dev/null 2>&1; then
    echo "  [skip] xelatex already installed"
  else
    echo "  [install] MacTeX (no GUI). This is a large download, give it time..."
    brew install --cask mactex-no-gui
    # mactex puts binaries in /Library/TeX/texbin; make this shell see them now
    export PATH="/Library/TeX/texbin:$PATH"
  fi

  if command -v pdftotext >/dev/null 2>&1; then
    echo "  [skip] poppler already installed"
  else
    echo "  [install] poppler (pdftotext)"
    brew install poppler
  fi
}

install_debian() {
  echo "  [install] TeX (xetex + fonts) and poppler via apt. You may be asked for your password."
  sudo apt-get update
  sudo apt-get install -y texlive-xetex texlive-fonts-recommended texlive-latex-extra poppler-utils
}

case "$OS" in
  Darwin) install_mac ;;
  Linux)
    if command -v apt-get >/dev/null 2>&1; then
      install_debian
    else
      echo "Linux without apt detected. Install a TeX distribution with xelatex and poppler"
      echo "using your package manager, then run: bash setup.sh"
      exit 1
    fi
    ;;
  *)
    echo "Unsupported OS: $OS"
    echo "Install a TeX distribution with xelatex (see requirements.md), then run: bash setup.sh"
    exit 1
    ;;
esac

echo
echo "Done. Verifying..."
echo
bash "$(dirname "$0")/setup.sh"
echo
echo "If xelatex still shows as missing, open a NEW terminal (so it picks up the"
echo "updated PATH) and run: bash setup.sh"
