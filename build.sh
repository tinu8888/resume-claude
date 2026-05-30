#!/usr/bin/env bash
# Build every resume in the workspace using XeLaTeX.
# Picks up the master resume and every jobs/<folder>/resume.tex automatically.
# Reports page counts. A tailored job resume should be 1 page; the master can
# run longer. Anything over the limit is flagged at the end.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

if ! command -v xelatex >/dev/null 2>&1; then
  echo "Error: xelatex not found. Install a TeX distribution first." >&2
  echo "See requirements.md (macOS: brew install --cask mactex-no-gui)." >&2
  exit 1
fi

WARNINGS=()

page_count() {
  # Echoes the page count of a PDF, or empty if pdfinfo isn't installed.
  local pdf="$1"
  if command -v pdfinfo >/dev/null 2>&1; then
    pdfinfo "$pdf" 2>/dev/null | awk '/^Pages:/ {print $2}'
  fi
}

build_one() {
  local tex_path="$1"
  local enforce_one_page="${2:-0}"
  if [ ! -f "$tex_path" ]; then
    echo "Skipping (not found): $tex_path"
    return
  fi
  local tex_dir tex_file base
  tex_dir="$(dirname "$tex_path")"
  tex_file="$(basename "$tex_path")"
  base="${tex_file%.tex}"

  echo "Building: $tex_path"
  (
    cd "$tex_dir"
    xelatex -interaction=nonstopmode -halt-on-error "$tex_file" >/dev/null
    xelatex -interaction=nonstopmode -halt-on-error "$tex_file" >/dev/null
    rm -f "$base".{aux,log,out,toc,fls,fdb_latexmk,synctex.gz}
  )

  local pdf="$tex_dir/$base.pdf"
  local pages
  pages="$(page_count "$pdf")"
  if [ -n "$pages" ]; then
    echo "  -> $pdf  (${pages} page(s))"
    if [ "$enforce_one_page" = "1" ] && [ "$pages" -gt 1 ]; then
      WARNINGS+=("$pdf is ${pages} pages. Tailored resumes should be 1 page. Trim the least relevant bullets, or run /jobupdate and ask Claude what to cut.")
    fi
  else
    echo "  -> $pdf"
  fi
}

# Master resume (multi-page is fine here)
build_one "$ROOT/resume/master/master_resume.tex" 0

# Every tailored resume under jobs/*/ (must be 1 page)
shopt -s nullglob
for tex in "$ROOT"/jobs/*/resume.tex; do
  build_one "$tex" 1
done
shopt -u nullglob

echo "All builds complete."

if [ "${#WARNINGS[@]}" -gt 0 ]; then
  echo
  echo "Page-length warnings:"
  for w in "${WARNINGS[@]}"; do
    echo "  - $w"
  done
  exit 0
fi
