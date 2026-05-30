---
name: jobupdate
description: Tailor a resume to one specific job description, built only from the master resume. Creates jobs/<job_id_or_company>/ with the JD, a tailored resume.tex, and a built PDF. Selects and reorders master content to match the JD, never invents, and asks the user about real gaps before adding anything. Use when the user runs /jobupdate or asks to tailor a resume to a job posting.
---

# /jobupdate — Tailor a resume to one job

Your job: build a resume tuned to one job description, drawn only from the master resume. You select, reorder, and trim. You do not create new experience.

Read the hard rules in `CLAUDE.md` first. The core rule: **tailoring is selection, not invention.** Everything on the tailored resume must already be true in `resume/master/master_resume.tex`. If the JD wants something the master doesn't show, you ask the user, you don't write it in.

## Step 1 — Check the master exists and is the user's own

Confirm `resume/master/master_resume.tex` exists and holds the user's real content. The file ships with sample data (a Tony Stark / Iron Man resume), marked at the top with `>>> THIS IS SAMPLE DATA`. If you see that marker, or the name is still "Tony Stark", the user hasn't built their master yet. Tell them to run `/start` first and stop. Never tailor the sample resume to a job.

## Step 2 — Get the job description and details

Ask the user for three things:

1. **The job description.** They can paste it into chat, or drop a file (PDF or text) anywhere and tell you the path.
2. **Company name** (required).
3. **Job ID** (optional).

Read the JD. If it's a PDF, use the Read tool or `pdftotext -layout`.

## Step 3 — Create the job folder

Pick the folder name:
- If the user gave a job ID, use it: `jobs/<job_id>/`.
- Otherwise use a sanitized company name, optionally with the role: `jobs/<company>/` or `jobs/<company>_<role>/` (lowercase, spaces to underscores, no special characters).

Create the folder. Save the job description there as `jobs/<folder>/job_description.txt` so there's a record of what you tailored against.

## Step 4 — Analyze and match

1. Pull the JD apart: required skills, must-have experience, responsibilities, and the keywords the role repeats.
2. Go through the master resume and decide, bullet by bullet:
   - **Keep and feature** bullets that match the JD. Put the strongest matches first.
   - **Keep but de-emphasize** bullets that are relevant but secondary.
   - **Drop** bullets that don't relate to this role.
3. Reorder experience bullets so the most relevant ones lead. Same for skills, list the JD's stack first (only skills already in the master).
4. Tighten the summary to point at this role, using only facts already in the master.

You may rephrase wording for emphasis. You may not add a skill, tool, metric, or responsibility that isn't in the master.

## Step 5 — Surface gaps as questions (do not fill them)

After matching, list anything the JD asks for that the master doesn't clearly cover. Present each as a question, not a gap to paper over:

> The JD asks for Kubernetes. I don't see it in your master. Have you worked with it, even on a side project or at a previous role?

For each gap:
- If the user says yes and gives you a real, specific detail, add a bullet for it. Then offer to also add it to the master so it's there next time.
- If the user says no or isn't sure, leave it out. Do not soften the JD requirement into a vague bullet to seem like a match.

Also offer suggestions where you see them: a bullet that would land harder if reworded for this JD, a section worth reordering, a stronger lead. Suggest, let the user decide.

## Step 6 — Write the tailored resume (one page, always)

Write `jobs/<folder>/resume.tex` using the same preamble and macros as `resume/master/resume_template.tex`. Same layout, same font setup. Add a comment header at the top with the role and job ID, like the master does.

**The tailored resume must fit one page.** This is the whole point of tailoring: the master holds everything, the job resume shows only what matters for this role. To stay on one page, drop the least relevant content first, in this rough order:

1. Older or unrelated jobs (or trim them to one or two lines).
2. Bullets that don't match the JD's keywords or responsibilities.
3. Optional sections the role doesn't care about (publications, awards, volunteer, extra projects).
4. The weakest bullet within each kept job.

Selection still comes only from the master. Cutting to fit one page is fine. Adding filler to fill a page is not.

## Step 7 — Build, check the page count, and report

1. Run `bash build.sh`. It picks up the new `jobs/<folder>/resume.tex` automatically and prints the page count for each PDF.
2. Fix any LaTeX errors (usually an unescaped `%`, `&`, `_`, `#`, or `$`) and rebuild.
3. **Check the page count.** `build.sh` flags any tailored resume over one page.
   - If `jobs/<folder>/resume.pdf` is one page, good.
   - If it spills to a second page, do not silently leave it. Tell the user what's pushing it over and suggest specific cuts, drawn from the order above. For example:

     > Your resume is running to 1.2 pages. To get it on one page I'd suggest cutting the [older role] bullets down to one line, and dropping the [project] section since the JD doesn't mention anything related. Want me to make those cuts, or would you rather trim something else?

   - Make the cuts the user approves, rebuild, and repeat until it's one page.
4. Report briefly:
   - What you led with and why.
   - What you trimmed and why.
   - Any gap questions still open (if the user hasn't answered them yet).

Point them to `jobs/<folder>/resume.pdf`. Keep the report short.

## Step 8 — Match score and how to raise it

End every run with a rough match score: how well the tailored resume lines up with the job description.

Work it out honestly. This is your own estimate, not a real ATS number, so say that. Base it on coverage:

1. List the JD's must-have requirements, core responsibilities, and repeated keywords.
2. Check how many of them the resume actually backs up with real experience from the master.
3. Score it: roughly `(requirements clearly covered / total key requirements) * 100`, rounded. Weight the must-haves more than the nice-to-haves. A resume that hits every must-have but misses a couple of optional skills is still a strong match.

Show it like this:

> Match estimate: about 78%.
> Strong: embedded C, RTOS, motor control, the driver work, your Amazon experience.
> Partial: the JD wants CAN bus depth, you have one bullet on it.
> Missing: Rust, and automotive ISO 26262 experience.

Then ask if they want to raise it, and suggest concrete ways, all of which respect the hard rule (selection, never invention):

- **Real experience you haven't listed.** Ask directly: "The JD weighs CAN bus heavily and you've got one line on it. Have you done more with CAN that we could pull from your background? If so, telling me gets the score up." If they confirm with real detail, add it (and offer to update the master).
- **Reordering or rewording.** Point out where leading with a different bullet, or matching the JD's exact wording for a tool you already use, would land harder.
- **A short skills line** for tools the user genuinely knows that the JD names but the resume doesn't surface (only if they're true).

Be honest about the ceiling. If the JD needs a skill the user does not have, say so plainly: the score won't reach 100% on this one, and padding it with things they haven't done is not an option. A truthful 75% beats a fake 95% that falls apart in the interview.

If the user adds real detail, rebuild, re-check the page count, and give the updated score.
