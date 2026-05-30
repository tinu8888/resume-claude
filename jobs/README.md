# Tailored resumes live here

You don't create folders here by hand. When you run `/jobupdate`, Claude makes one folder per job:

```
jobs/
└── <job_id_or_company>/
    ├── job_description.txt   # the JD you tailored against
    ├── resume.tex            # the tailored resume
    └── resume.pdf            # the built PDF
```

The folder is named after the job ID if you give one, otherwise the company name.

Every `resume.tex` here is built from your master resume in `resume/master/`. Nothing on a tailored resume is invented, it's all selected from the master.
