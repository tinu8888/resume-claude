---
name: start
description: Build the user's master resume from their LinkedIn profile PDF and an optional old resume, going section by section and confirming each before writing. Produces resume/master/master_resume.tex and a built PDF. Use when the user runs /start or asks to set up or build their master resume from scratch.
---

# /start — Build the master resume

Your job: turn the user's LinkedIn profile (and any old resume) into one clean master resume at `resume/master/master_resume.tex`, then build it to PDF. The master is the single source of truth for every tailored resume later.

Follow the writing rules and the hard rules in `CLAUDE.md`. The most important one: **never invent experience, skills, projects, or numbers.** If a fact is not in the user's sources, ask. Do not fill gaps.

## Step 1 — Get the inputs

1. Check `inputs/linkedin/` for a PDF. If it is empty, ask the user to add it and stop until they do:

   > Download your LinkedIn profile as a PDF and drop it in `inputs/linkedin/`.
   > On LinkedIn: go to your profile, click "Resources" (or the "More" button under your name), then "Save to PDF". Tell me when it's there.

2. Check `inputs/old_resume/` for an old resume (PDF or text). This is optional. Ask:

   > If you have an old resume, drop it in `inputs/old_resume/` for reference. If not, that's fine, we'll work from LinkedIn.

3. Read the files. Use the Read tool directly on the PDFs. If a PDF won't read cleanly, fall back to `pdftotext -layout <file>` (see requirements.md). Pull out everything: name, contact info, location, summary/about, every job (company, title, location, dates, bullets), education, projects, skills, publications, awards, volunteer work, certifications.

## Step 2 — Confirm contact details

Show the user the contact block you extracted (name, phone, email, GitHub, LinkedIn URL, location). Ask them to confirm or correct each. Don't guess a phone number or email if it isn't in the sources, ask for it.

## Step 3 — Go section by section

Walk through the resume one section at a time, in this order. Skip a section if the user has nothing for it.

1. Summary
2. Experience (one job at a time)
3. Education
4. Projects
5. Skills Summary
6. Volunteer Experience (optional)
7. Publications (optional)
8. Honors and Awards (optional)
9. Certifications (optional)

Include every section the user has real content for, the master is meant to be complete. Drop any section they have nothing for. All of `resume/master/resume_template.tex` is there as the reference for how each section is written.

For each section:

1. Show what you found in the sources (raw, so they can see it).
2. Offer three choices in plain words:
   - **Keep** it as is.
   - **Update** it (they tell you what to change).
   - **Suggest** a stronger version. If they pick this, rewrite using the resume writing rules in CLAUDE.md: active voice, past-tense verbs, concrete results, no fluff, no banned words, no em dashes. Keep every fact true to the source. Tighten wording, do not add claims.
3. When a bullet is vague (a responsibility with no outcome), ask if they have a number or result you can add. If they don't, leave it qualitative. Do not make a number up.
4. Confirm the section before moving on.

Keep it moving. Don't dump all sections at once. One section, get the answer, next section.

## Step 4 — Write the master

`resume/master/master_resume.tex` currently holds sample data (a Tony Stark / Iron Man resume) so the user can see what a finished resume looks like. **Replace all of it with the user's real content.** Keep none of the sample text.

Build the new `resume/master/master_resume.tex` from the structure in `resume/master/resume_template.tex`. Reuse the exact preamble and macros. Fill in the confirmed content. Match the macro patterns already in the template:

- `\resumeSubheadingCompact{Company (Title)}{Location}{Dates}` for each job, followed by an `itemize` of bullets.
- `\resumeSubItem{Title}{Description}` for projects, volunteer, publications, awards.
- `\resumeSubheading{...}{...}{...}{...}` for education.

Drop any section the user has no content for. Keep the master complete: it should hold everything true about the user, even bullets that won't fit on a one-page tailored resume later. Tailoring trims; the master is the full record.

## Step 5 — Build, then ask the user to review

1. Run `bash build.sh` from the workspace root.
2. If XeLaTeX errors, read the message, fix the `.tex` (usually an unescaped `%`, `&`, `_`, `#`, or `$`), and rebuild.
3. The master can run to two or three pages, that is fine. It is meant to hold everything true about the user, so `/jobupdate` has the full set of bullets to pick from later. If `build.sh` notes the master is multiple pages, tell the user not to worry, the master is supposed to be long. Only the tailored resumes need to fit one page.
4. Ask the user to review it:

   > Open `resume/master/master_resume.pdf` and read it over. Want me to change anything, fix a date, reword a bullet, add something I missed, drop something? Don't worry about length here, the master is meant to be complete. We trim it down per job later with /jobupdate.

5. Make any edits the user asks for, rebuild, and repeat until they're happy.
6. When they're done, tell them the next step is `/jobupdate` whenever they have a job description.

Do not write a long summary of what you did. A short confirmation is enough.
