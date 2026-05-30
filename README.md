# Resume builder, run by Claude

A small workspace for writing and tailoring resumes with Claude Code. Clone or copy the folder, open it with Claude (terminal, desktop app, or an IDE extension), and two skills do the work:

- **`/start`** builds your master resume from your LinkedIn profile and an old resume.
- **`/jobupdate`** tailors a fresh resume to a specific job, built only from your master, and gives it an ATS score.
- **`/atscheck`** runs a standalone ATS review of any resume with a 0-100 score and fixes.

It's deliberately low on dependencies: one TeX distribution to make PDFs, and that's it. No Python, no pip, no Node.

Everything Claude writes follows a strict human-writing style (see `CLAUDE.md`): plain language, no AI filler, no em dashes, no buzzwords. This is always on while Claude runs in this folder, and it's backed by a full `humanizer` skill (based on Wikipedia's "Signs of AI writing") that strips the usual AI tells from any text. And it never invents experience you don't have.

---

## What you need to run this

This runs on **Claude Code**, the agent that reads your files and runs the skills. That means you need one of:

- a **Claude Pro or Max** subscription, or
- **Anthropic API billing** (an API key with credits).

**A free claude.ai account will not work.** The free web chat can't open a folder, run a skill, or build a PDF. If you only have the free tier, you'd be copy-pasting text by hand and losing everything this folder automates.

### Don't want to use the terminal?

You don't have to. Claude Code runs in the **desktop app** (Mac/Windows), the **web app** at claude.ai/code, and **IDE extensions** (VS Code, JetBrains), not only the terminal.

Open the Claude app, set this folder as your project, and type `/start`, `/jobupdate`, or `/build` right there. The skills and settings live in the folder, so any Claude surface that opens it picks them up.

One thing stays the same whichever way you go: the PDF build runs on your own machine, so you still need a TeX distribution installed (the `bash install.sh` step below). If you're not into the terminal, just open the app on this folder and tell Claude "run install.sh and fix anything missing", and it'll handle the setup for you.

---

## Setup (once)

**1. Install Claude Code** if you don't have it: https://claude.com/claude-code

**2. Install everything else with one command.** Open a terminal in this folder and run:

```
bash install.sh
```

This installs a TeX distribution (to make PDFs) and poppler, on both macOS (via Homebrew, which it installs for you if missing) and Debian/Ubuntu (via apt). It's safe to run again, it skips anything already there. Full details of what gets installed are in [`requirements.md`](requirements.md).

**3. Check it worked:**

```
bash setup.sh
```

You should see `xelatex found`. If it still says missing right after install, open a **new** terminal (so it picks up the updated PATH) and run `bash setup.sh` again.

---

## How to use it

Open a terminal, go into this folder, and start Claude:

```
cd path/to/resume-claude
claude
```

(Drag the folder into the terminal after `cd ` to get its path, then press Enter.) Claude now runs with this folder as its workspace, so the `/start`, `/jobupdate`, and `/build` skills are available.

> **Want to see the end result first?** Open `resume/master/master_resume.pdf`. It ships with a filled-in sample resume (Tony Stark / Iron Man) so you can see the layout and every section before you build your own. Running `/start` replaces it with your details.

### Step 1 — Build your master resume: `/start`

1. Download your LinkedIn profile as a PDF (profile → "Resources" or "More" → "Save to PDF") and drop it in `inputs/linkedin/`.
2. Optional: drop an old resume in `inputs/old_resume/`.
3. In Claude, type:
   ```
   /start
   ```

Claude reads your profile, then walks you through each section (summary, experience, education, projects, skills). For each one it shows what it found and asks: keep it, update it, or let it suggest a stronger version. It only uses facts from your sources, and asks you when something's missing instead of guessing.

When it's done it builds `master_resume.pdf` and asks you to review it. Tweak anything you want and it'll rebuild. Don't worry if the master runs to two or three pages, it's meant to be complete. It holds everything about you, and `/jobupdate` trims it down per job. This master is the source for every tailored resume.

### Step 2 — Tailor a resume to a job: `/jobupdate`

1. In Claude, type:
   ```
   /jobupdate
   ```
2. Paste the job description (or point Claude to a file), give the company name, and a job ID if you have one.

Claude creates `jobs/<job_id_or_company>/`, then selects and reorders the right bullets from your master to match the job. It does not add anything that isn't already in your master. Where the job asks for something you haven't listed, it asks you ("have you worked on anything like this?") instead of inventing a match. If you confirm with a real detail, it adds it and offers to update your master too.

The tailored resume is built to fit **one page**. If it spills over, Claude tells you exactly what to cut to get it back down (older roles, off-topic bullets, sections the job doesn't care about) and trims it with your okay. You get a tailored `resume.tex` and `resume.pdf` in the job folder, plus a short note on what it led with and what it trimmed.

At the end it gives you a **rough match score** (an estimate of how well the resume fits the JD), shows what's strong, partial, and missing, then asks if you want to raise it and suggests honest ways to do that. If you've done something relevant that isn't on the resume yet, tell Claude and it pulls it in. It won't pad the score with things you haven't done.

### Rebuild PDFs anytime: `/build`

```
/build
```

Compiles the master and every tailored resume, and reports each one's page count. Same as running `bash build.sh` yourself.

### Get an ATS score: `/atscheck`

```
/atscheck
```

Runs an ATS (Applicant Tracking System) review and gives a 0-100 score with a category breakdown, the same idea as Resume Worded or Jobscan. It reads the resume the way an ATS does (the PDF's text layer) and scores keyword match against the JD, formatting, section completeness, content quality, and contact basics, then lists specific fixes to raise the score.

`/jobupdate` already gives you this score at the end of every tailored resume. Run `/atscheck` on its own to score your master, an older resume, or recheck after edits. The rubric it uses is in [`references/ats-guidelines.md`](references/ats-guidelines.md). It won't pad the score with skills you don't have.

### Clean up any text: `/humanizer`

```
/humanizer
```

Paste any text (a cover letter, a LinkedIn About, an email) and it rewrites the AI tells out: em dashes, filler, buzzwords, rule-of-three padding, and the rest. The same rules run automatically on everything Claude writes here, so you mostly won't need to call this by hand. It's there for when you want to clean up text you wrote elsewhere.

---

## If something goes wrong

- **`bash install.sh` failed or you skipped it** — start Claude in this folder (`claude`) and just say: *"run install.sh and fix any errors."* Claude will run it, read the output, and sort out what's missing.
- **`xelatex: command not found` when building** — the TeX install isn't on your PATH yet. Open a new terminal and run `bash setup.sh`. If it still can't find it, run `bash install.sh` again.
- **A resume won't compile** — start Claude here and say *"the build is failing, fix it."* Compile errors are almost always one stray character in the `.tex`, and Claude will find and fix it.
- **A skill doesn't show up** — make sure you started `claude` from inside this folder, not your home directory. The skills live in `.claude/skills/` here.

When in doubt: start Claude in this folder and describe the error in plain words. It can read the files, run the scripts, and fix things for you.

## A note on the trigger

In Claude Code you run a skill by typing a slash and its name: `/start`, `/jobupdate`, `/build`. You can also just ask in plain English ("build my master resume") and Claude will pick the right skill.

---

## Folder layout

```
.
├── CLAUDE.md                  # writing rules + workflow rules Claude follows
├── README.md                  # this file
├── requirements.md            # what to install
├── install.sh                 # one command to install it all
├── setup.sh                   # checks your machine
├── build.sh                   # compiles every resume to PDF
├── .claude/skills/            # /start, /jobupdate, /atscheck, /build, /humanizer
├── references/ats-guidelines.md  # the ATS scoring rubric the skills follow
├── inputs/
│   ├── linkedin/              # your LinkedIn profile PDF goes here
│   └── old_resume/            # an old resume (optional)
├── resume/master/
│   ├── resume_template.tex    # the LaTeX structure (reference, not edited)
│   ├── master_resume.tex      # your master resume
│   └── master_resume.pdf
└── jobs/
    └── <job_id_or_company>/   # one folder per role, made by /jobupdate
```

---

## The rules Claude won't break

These are in `CLAUDE.md` and apply to everything it writes:

- Never adds experience, skills, projects, or numbers you haven't actually done.
- Never inflates a metric to match a senior-sounding job.
- Asks before guessing. If your sources don't show something, it asks you.
- Tailoring is selection, not creation. It picks and reorders from your master, nothing more.
- Keeps your master clean. Edits to the master are a separate, deliberate step you ask for.

---

## Editing the LaTeX yourself

The resume uses a simple set of macros (`\resumeSubheadingCompact`, `\resumeSubItem`, and so on). They're all defined and documented in `resume/master/resume_template.tex`. If you want to hand-edit, start there, then run `bash build.sh`.

Want a different look or font? The template auto-picks a font that exists on your machine (Arial/Helvetica/TeX Gyre Heros/Latin Modern), so it builds anywhere. To force a specific one, edit the `\setmainfont` block at the top of the template. The rest of the layout lives in that one file.

---

## Credits

- Writing cleanup is powered by the [humanizer](https://github.com/blader/humanizer) skill by blader (MIT License), based on Wikipedia's [Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing).

## License

MIT. See [LICENSE](LICENSE). The bundled humanizer skill is MIT-licensed by its author; its license and attribution are kept intact.
