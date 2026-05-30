# Requirements

Install these before running anything. The list is short on purpose: one TeX distribution does almost everything, and Claude reads your PDFs on its own.

## Required

**1. Claude Code**
The CLI that runs the skills. Install from https://claude.com/claude-code

**2. A TeX distribution with XeLaTeX**
Used to compile the resume `.tex` files into PDFs.

- **macOS:**
  ```
  brew install --cask mactex-no-gui
  ```
  (smaller than full MacTeX, has everything here). After install, open a new terminal so `xelatex` is on your PATH.

- **Ubuntu / Debian:**
  ```
  sudo apt-get install texlive-xetex texlive-fonts-recommended texlive-latex-extra
  ```

- **Windows:** install MiKTeX (https://miktex.org) or TeX Live. MiKTeX fetches missing packages on first build.

**Fonts:** nothing to install. The template auto-picks the first font it finds: Arial or Helvetica (on every Mac), then TeX Gyre Heros (ships with full TeX Live on Linux), then Latin Modern as a built-in fallback. So it builds on any machine without edits. To force a specific font, edit the `\setmainfont` block in `resume/master/resume_template.tex`.

LaTeX packages used, all included in the distributions above: `geometry`, `titlesec`, `color`, `enumitem`, `hyperref`, `fancyhdr`, `setspace`, `fontspec`. If you used BasicTeX and a package is missing, install it with `tlmgr install <package>`.

## Optional

**poppler** — gives you `pdftotext` (a fallback for reading PDFs) and `pdfinfo` (used by `build.sh` to report page counts and warn when a tailored resume runs over one page). The build works without it, you just lose page-count reporting.
- macOS: `brew install poppler`
- Ubuntu/Debian: `sudo apt-get install poppler-utils`

`bash install.sh` installs poppler for you.

## Check your machine

Run `bash setup.sh` to see what's installed and what's missing.

No Python, Node, or pip packages are needed. There is no `pip install` step.
