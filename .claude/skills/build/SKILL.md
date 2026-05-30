---
name: build
description: Compile every resume in the workspace to PDF with XeLaTeX by running build.sh. Use when the user runs /build or asks to rebuild, compile, or regenerate their resume PDFs.
---

# /build — Compile all resumes to PDF

Run `bash build.sh` from the workspace root. It compiles `resume/master/master_resume.tex` and every `jobs/<folder>/resume.tex`, cleans up the LaTeX aux files, and prints each PDF's page count.

A tailored job resume should be one page. `build.sh` flags any that run longer. The master is exempt, it can be several pages. If a job resume is over a page, tell the user what to cut to get it down (see the `/jobupdate` skill) rather than leaving it. Page counts need `pdfinfo` (from poppler); without it the build still works, it just won't report pages.

If it fails:

- **`xelatex not found`** — the user needs a TeX distribution. Point them to `requirements.md` (macOS: `brew install --cask mactex-no-gui`).
- **A LaTeX compile error** — read the message. It's almost always an unescaped special character in the `.tex` (`%`, `&`, `_`, `#`, `$`) or a missing brace. Fix the file and rebuild.
- **Font error** — the template auto-picks Arial/Helvetica/TeX Gyre Heros/Latin Modern, so this is rare. If it happens, the TeX install is missing all four. Have the user install a TeX distribution per `requirements.md`, or point `\setmainfont` at a font they have.

Report which PDFs built and where they are. Keep it short.
