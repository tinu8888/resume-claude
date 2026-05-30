#!/usr/bin/env bash
# Check that the tools this workspace needs are installed.
# This only checks. It does not install anything.

echo "Checking your machine for the resume workspace..."
echo

ok=1

if command -v xelatex >/dev/null 2>&1; then
  echo "  [ok]      xelatex found  ->  $(command -v xelatex)"
else
  echo "  [MISSING] xelatex not found."
  echo "            macOS:  brew install --cask mactex-no-gui"
  echo "            Ubuntu: sudo apt-get install texlive-xetex texlive-fonts-recommended texlive-latex-extra"
  echo "            Windows: install MiKTeX (https://miktex.org)"
  ok=0
fi

if command -v pdftotext >/dev/null 2>&1; then
  echo "  [ok]      pdftotext found (optional)"
else
  echo "  [info]    pdftotext not found (optional, only a fallback for reading PDFs)."
  echo "            macOS: brew install poppler   Ubuntu: sudo apt-get install poppler-utils"
fi

echo
if [ "$ok" -eq 1 ]; then
  echo "You're set. Open Claude in this folder and run /start."
else
  echo "Install the missing item above, open a new terminal, then run this again."
fi
