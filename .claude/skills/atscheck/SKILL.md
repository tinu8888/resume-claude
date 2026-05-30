---
name: atscheck
description: Run an ATS (Applicant Tracking System) review on a resume and give a 0-100 score with a category breakdown and specific fixes, like Resume Worded or Jobscan. Works on a tailored job resume (scored against its job description) or the master (general ATS readiness). Use when the user runs /atscheck or asks for an ATS score, resume score, or ATS review.
---

# /atscheck — ATS review and score

Score a resume the way an ATS and a checker like Resume Worded would. Use the rubric in `references/ats-guidelines.md` as the source of truth for categories, weights, and benchmarks. Read it before scoring.

The honesty rule from `CLAUDE.md` overrides everything here: never suggest adding a skill or experience the user doesn't have to raise the score.

## Step 1 — Pick the resume and the JD

- If the user names a job, or there's an obvious recent one, use `jobs/<folder>/resume.pdf` and its `jobs/<folder>/job_description.txt`. Score against that JD.
- If they point at the master, or no JD exists, score `resume/master/master_resume.pdf` for general ATS readiness (no-JD mode in the rubric).
- They can also give a path to any external PDF. Ask which resume and whether there's a JD if it's unclear.

## Step 2 — Read what the ATS reads

Extract the text layer, because that's all an ATS sees:

```
pdftotext -layout "<resume.pdf>" -
pdftotext "<resume.pdf>" -
```

If the output is empty or garbled, that's a category-2 failure: the PDF is image-based and most ATS will reject it. Flag it and stop scoring until it's fixed. (Resumes built here are always text-based, so this only happens with external PDFs.)

Then read the JD (the `job_description.txt` or what the user pasted) and pull out its hard skills, tools, certifications, titles, and repeated terms.

## Step 3 — Score the five categories

Score each category from the rubric, then combine with the rubric's weights (JD mode or no-JD mode):

1. **Keyword / skills match vs JD** — how many of the JD's must-have skills, tools, and terms appear in the resume text, phrased the way the JD phrases them. Back every match with real experience from the resume.
2. **Formatting and parseability** — did the text extract cleanly, single column, standard headings, real bullets, no tables/images/header-footer content.
3. **Section completeness** — Summary, Experience (with title, company, location, dates), Education, Skills present and conventionally named.
4. **Content quality** — quantified achievements, past-tense action verbs, results over duties.
5. **Contact and basics** — email, phone, location, LinkedIn, all in the body text.

## Step 4 — Report the score

Give a clear, Resume-Worded-style report:

```
ATS score: 72 / 100   (readable, but has gaps)

Keyword match vs JD ...... 26 / 40
Formatting ............... 20 / 20
Sections ................. 15 / 15
Content quality .......... 8 / 15
Contact & basics ......... 3 / 10
```

Then, in plain words:

- **Strong:** what's working (clean parse, good sections, strong matches).
- **Missing keywords:** JD terms not on the resume. For each, ask whether the user actually has it ("The JD wants CI/CD pipelines and I don't see it. Have you set those up?"). Only add confirmed ones.
- **Fixes that raise the score:** specific, concrete edits. For example: "Three of your six bullets have no number. Add a metric to the deployment bullet if you have one." Or: "Add your phone number, it's missing." Or: "The JD says Kubernetes; you wrote K8s. Match their wording."
- **Benchmark:** where the score sits (75+ strong, 60 to 74 gaps, below 60 likely filtered) and what it would take to clear 75.

## Step 5 — Offer to apply fixes

Ask if they want you to make the changes you can make honestly (rewording for keyword match, adding quantification they provide, fixing a missing contact field, reordering). Then rebuild with `bash build.sh`, re-extract, and give the updated score. For a tailored resume, keep it to one page (see `/jobupdate`).

Be honest about the ceiling. If the JD needs a skill the user lacks, say the score won't reach the top and padding it is not an option. A real 75 beats a fake 90.
