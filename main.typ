#import "@preview/diatypst:0.9.3": *
#import "@preview/gentle-clues:1.3.1": *

#let rocket-gold = rgb("#EDBB27")
#let night = rgb("#090B0D")

// Custom title slide. Keep this before `slides.with`, as required by diatypst.
#set page(
  width: 16 / 9 * 10.5cm,
  height: 10.5cm,
  margin: 0pt,
  header: none,
  footer: none,
  fill: night,
)
#set text(font: "IBM Plex Mono", fill: white)

#place(
  top + right,
  rect(width: 170pt, height: 100%, fill: rgb("#F4F3EE")),
)

#place(
  top + right,
  dx: -6pt,
  dy: 77pt,
  image("assets/logo/colour_noletters_standard.png", width: 157pt),
)

#place(
  left + top,
  dx: 39pt,
  dy: 33pt,
  text(size: 8pt, fill: rocket-gold, weight: "bold")[
    WATERLOO ROCKETRY
  ],
)

#place(
  left + top,
  dx: 39pt,
  dy: 67pt,
  block(width: 327pt)[
    #text(size: 28pt, weight: "bold", fill: white)[Git Tutorial]
    #v(10pt)
    #rect(width: 54pt, height: 3pt, fill: rocket-gold, radius: 2pt)
    #v(16pt)
    #text(size: 11pt, fill: rgb("#D9DDE2"))[Software Sub-System]
  ],
)

#place(
  left + bottom,
  dx: 39pt,
  dy: -30pt,
  text(size: 9pt, fill: rgb("#C1C8D0"))[Qian Qian  ·  Shrey Shingala],
)

#place(
  right + bottom,
  dx: -30pt,
  dy: -30pt,
  text(size: 6pt, fill: rgb("#8B949E"))[WATERLOO ROCKETRY],
)

// Preserve the diatypst setup for future tutorial slides.
#show: slides.with(
  title: "Git Tutorial",
  subtitle: "Software Sub-System",
  authors: ("Qian Qian", "Shrey Shingala"),
  ratio: 16 / 9,
  layout: "medium",
  title-color: rocket-gold,
  bg-color: night,
  footer: true,
  footer-title: [
    #block(width: 100%, inset: (top: 1pt, bottom: 2pt))[
      #align(left)[#move(dy: -7.5pt)[Git Tutorial]]
    ]
  ],
  footer-subtitle: [
    #block(width: 100%, inset: (top: 1pt, bottom: 2pt))[
      #align(right)[
        #move(dy: -7.5pt)[
          #move(dy: -3pt)[
            #box(height: 10pt)[
              #image("assets/logo/colour_noletters_inverted.png", height: 10pt)
            ]
          ]
        ]
      ]
    ]
  ],
  toc: false,
  count: none,
  first-slide: false,
)

// Suppress diatypst's default footer divider.
#show line: _ => []
#show raw: set text(fill: rgb("#1C2229"))

#set heading(numbering: (..nums) => {
  if nums.pos().len() == 1 {
    str(nums.pos().at(0) - 1)
  } else {
    numbering("1.1", ..nums.pos())
  }
})

== Schedule

#text(size: 15pt, fill: rgb("#C1C8D0"))[Today’s route through Git]

#let agenda-item(number, title, detail, title-size: 10pt) = block(
  width: 100%,
  height: 78pt,
  inset: 12pt,
  radius: 6pt,
  fill: rgb("#15191E"),
)[
  #text(size: 11pt, weight: "bold", fill: rocket-gold)[#number]
  #v(5pt)
  #box(text(size: title-size, weight: "bold")[#title])
  #v(5pt)
  #text(size: 6.5pt, fill: rgb("#AEB7C2"))[#detail]
]

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  row-gutter: 16pt,
  agenda-item("01", "Git Background", "Origins and mental model"),
  agenda-item("02", "Git Clients", "CLI, lazygit, and GUI clients"),
  agenda-item("03", "Remote Setup & GitHub", "GitHub and remotes"),
  agenda-item("04", "Git Setup & Basics", "Setup, stage, commit, inspect"),
  agenda-item("05", "Team Collaboration", "Branches, merges, PRs, reviews"),
  agenda-item("06", "Hands-On", "Practice the full workflow"),
)

== Good SWE Practices

#text(size: 15pt, fill: rgb("#C1C8D0"))[Habits that help a team ship reliable software]

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  row-gutter: 16pt,
  agenda-item("01", "Clear Naming", "Clear commits and branches"),
  agenda-item("02", "Write Clearly", "Clear PR descriptions"),
  agenda-item("03", "Small Changes", "Focused pull requests"),
  agenda-item("04", "Code Review", "A second set of eyes"),
  agenda-item("05", "Detailed Testing", "Verify before merging"),
  agenda-item(
    "06",
    "Document Things",
    "Decisions, usage, and comments",
  ),
)

// Reusable content block for the remaining tutorial slides.
#let lesson-card(title, body) = block(
  width: 100%,
  inset: 12pt,
  radius: 6pt,
  fill: rgb("#15191E"),
)[
  #text(size: 11pt, weight: "bold", fill: rocket-gold)[#title]
  #v(6pt)
  #text(size: 8pt, fill: rgb("#D9DDE2"))[#body]
]

#let graph-node(label, caption, color: rocket-gold) = box(
  width: 58pt,
)[
  #align(center)[
    #circle(radius: 10pt, fill: color)[
      #align(center + horizon)[
        #text(size: 8pt, weight: "bold", fill: night)[#label]
      ]
    ]
    #v(4pt)
    #text(size: 6pt, fill: rgb("#AEB7C2"))[#caption]
  ]
]

#let graph-arrow = text(size: 16pt, fill: rgb("#F4F3EE"))[→]

= Announcements

== Announcements

1. _*Do your #underline[safety training]!*_ \ (We might do a short pause during this tutorial for people having to attend the bay safety tour to go do that and come back.)
2. We will start a thread in the team Slack or create a form to collect your GitHub username. This is needed to send you an invitation to the Waterloo Rocketry GitHub organization.

= Git Background

== Why Git Exists

#text(size: 15pt, fill: rgb("#C1C8D0"))[Git lets a team make changes independently without losing shared history.]

#v(20pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("Versioned History", [Every commit records a checkpoint: who changed what, when, and why. You can compare, restore, and audit work without copying folders.]),
  lesson-card("Distributed By Design", [Every clone gets you a full copy of the repository with all the history. Work offline, make changes and additions to the history, then synchronize.])
)

== Git History Is A Graph

#text(size: 15pt, fill: rgb("#C1C8D0"))[Commits link to parents: Git stores a graph, not copies of entire projects.]

#v(20pt)

#align(center)[
  #graph-node("A", "Initial") #h(4pt) #graph-arrow #h(4pt)
  #graph-node("B", "Add API") #h(4pt) #graph-arrow #h(4pt)
  #graph-node("C", "Fix Route") #h(4pt) #graph-arrow #h(4pt)
  #graph-node("D", "Release")
]

#v(12pt)

#align(center)[
  #text(size: 8pt, fill: rgb("#C1C8D0"))[Commit = snapshot · Parent = earlier commit · Branch = movable name]
]

== The Git Mental Model

#text(size: 15pt, fill: rgb("#C1C8D0"))[Most Git confusion disappears when you separate these four places.]

#v(18pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  row-gutter: 14pt,
  lesson-card("Working Tree", [The files on your computer. Edit here.]),
  lesson-card("Staging Area", [The exact snapshot selected for the next commit.]),
  lesson-card("Local Repository", [Your committed history and branches on this machine.]),
  lesson-card("Remote Repository", [The shared copy on GitHub, usually named `origin`.]),
)

== A Commit Is A...

#text(size: 15pt, fill: rgb("#C1C8D0"))[Use the model that helps with the question in front of you.]

#v(12pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Snapshot (Actually)", [Git represents a commit as a directory tree plus metadata and parent pointers. Checking out an old commit does not replay every prior diff.]),
  lesson-card("Diff", [Best for review: what changed between two states? GitHub, Tower, and lazygit make this view immediate.]),
)

#v(24pt)

#text(size: 7pt, fill: rgb("#AEB7C2"))[Further reading: Julia Evans, “Do we think of git commits as diffs, snapshots, and/or histories?”]

= Git Clients

== Git Clients

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("CLI", [Best for learning the model, scripting repeatable work, and seeing every operation explicitly.]),
  lesson-card("TUI", [`lazygit` is a useful terminal interface for staging, browsing history, and resolving routine work quickly.]),
  lesson-card("GUI", [Tower and GitHub Desktop make history, diffs, and repository state easy to inspect visually.]),
)

#v(16pt)

#lesson-card("Choose Deliberately", [Use the client that makes you confident. Learn the CLI vocabulary anyway: it transfers across tools and is invaluable when troubleshooting.])

== Set Up Your Client

#text(size: 13pt, fill: rgb("#C1C8D0"))[Configure your identity and authentication once in the client you will use day to day.]

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("GitHub Desktop", [Sign in with your GitHub account and confirm the organization is visible. Its credential flow handles cloning and pushing.]),
  lesson-card("Tower Or Another Client", [Set your Git identity and preferred authentication method in Settings (differ from client to client). Use a personal access token for HTTPS or an SSH key for SSH.]),
)

= Remote Setup & GitHub

== Create Your GitHub Account

#text(size: 14pt, fill: rgb("#C1C8D0"))[Your GitHub account is your identity for repositories, reviews, organization access, and contribution history.]

#v(16pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("Register", [Open `github.com/signup`, choose a professional username, and use an email address you can access. Complete the verification email before continuing.]),
  lesson-card("Secure It", [Enable two-factor authentication, save recovery codes somewhere safe, and add a profile name people on the team can recognize.]),
)

#pagebreak()

#lesson-card("For Waterloo Rocketry", [
  We will start a thread in the team Slack or create a form to collect your GitHub username.

  We will then send an invitation to the Waterloo Rocketry GitHub organization.

  Accept the organization invitation sent to your GitHub account. Confirm that the organization appears in the account menu before trying to push to a team repository.
])

== Create The Empty GitHub Repository

#text(size: 13pt, fill: rgb("#C1C8D0"))[You already have a local Git repository. Create its matching home on GitHub without adding a second initial commit.]

#v(12pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("1. New Repository", [On GitHub, select + then New repository. Choose your personal account or the organization that should own the project.]),
  lesson-card("2. Name & Visibility", [Use the intended project name. Choose Private for team work unless the project is deliberately public.]),
  lesson-card("3. Leave It Empty", [Do not initialize with a README, .gitignore, or license. Your existing local repository already has its own history.]),
)

== Copy The Remote Address

#text(size: 13pt, fill: rgb("#C1C8D0"))[After creating the repository, copy its URL from the Quick Setup page or the Code button. Pick one connection method and use it consistently.]

#v(12pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("HTTPS", [Works everywhere. Authenticate with GitHub CLI or a credential manager; GitHub does not accept account passwords for command-line Git operations.]),
  lesson-card("SSH", [Convenient once configured. Generate an SSH key for this computer, add its public key to GitHub, then copy the `git@github.com:OWNER/REPOSITORY.git` URL.]),
)

== Attach The Remote To Your Existing Repository

#text(size: 13pt, fill: rgb("#C1C8D0"))[In a terminal, open the existing project folder. `origin` is the conventional name for its primary GitHub remote.]

#v(10pt)

#lesson-card("Add", [#raw("git remote add origin git@github.com:OWNER/REPOSITORY.git", block: true, lang: "bash")])
#lesson-card("Verify", [#raw("git remote -v", block: true, lang: "bash")])

#v(14pt)

#lesson-card("Read The Result", [The verification output should show the same `origin` URL for fetch and push. Check the owner and repository name carefully before you publish anything.])

== Publish The Existing History

#text(size: 13pt, fill: rgb("#C1C8D0"))[Push the branch you already have. The `-u` flag remembers the matching GitHub branch, so later `git push` and `git pull` know where to go.]

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("Check The Branch", [#raw("git branch --show-current", block: true, lang: "bash")]),
  lesson-card("First Push", [#raw("git push -u origin main", block: true, lang: "bash")]),
)

#pagebreak()

#lesson-card("If Your Branch Is Not `main`", [Replace `main` with the output from `git branch --show-current`. Refresh the GitHub repository page after the push and confirm the files and commit history arrived.])

== Inspect Or Repair A Remote

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Address", [Check that `origin` points to the expected GitHub organization and repository before you push.]),
  lesson-card("Branches", [Fetch to learn which branches exist on GitHub and whether your branch is ahead or behind its remote-tracking branch.]),
  lesson-card("Permission", [A successful fetch confirms read access. Push only to the branch and repository your team expects.]),
)

#v(14pt)

#lesson-card("Already Have `origin`?", [Do not add it again. Inspect with `git remote -v`, then correct an outdated address with `git remote set-url origin <REMOTE-URL>`.])

= Git Setup & Basics

== Configure Your Git Identity

#text(size: 13pt, fill: rgb("#C1C8D0"))[Set the name and email Git writes into every commit. Use the email address verified on GitHub so your work appears on your profile.]

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("Your Name", [#raw("git config --global user.name \"Your Name\"", block: true, lang: "bash")]),
  lesson-card("Your Email", [#raw("git config --global user.email \"you@example.com\"", block: true, lang: "bash")]),
)

#pagebreak()

#lesson-card("Why `--global`?", [It sets the default for every repository on this computer. A project can override it with the same command without `--global` when needed.])

== Start A New Project

#text(size: 13pt, fill: rgb("#C1C8D0"))[Use this path when you are beginning with a folder of files and neither a local repository nor a GitHub repository exists yet.]

#v(10pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("1. Create The Folder", [#raw("mkdir flight-dashboard\ncd flight-dashboard", block: true, lang: "bash")]),
  lesson-card("2. Initialize Git", [#raw("git init", block: true, lang: "bash")]),
  lesson-card("3. Confirm", [#raw("git status", block: true, lang: "bash")]),
)

#pagebreak()

#lesson-card("What `git init` Does", [It creates the hidden `.git` directory that stores commits, branches, and configuration. Your project files remain ordinary files until you add and commit them.])

== Create The First Commit

#text(size: 13pt, fill: rgb("#C1C8D0"))[Create the initial files in your editor first: a README, source folder, project configuration, and `.gitignore` are common starting points. Then save the first snapshot.]

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Inspect", [#raw("git status", block: true, lang: "bash")]),
  lesson-card("Stage", [#raw("git add .", block: true, lang: "bash")]),
)

#lesson-card("Commit", [#raw("git commit -m \"chore: initialize repository\"", block: true, lang: "bash")])

#pagebreak()

#lesson-card("Before `git add .`", [Check `git status` and your `.gitignore`. Never add credentials, API keys, build outputs, or local editor settings that do not belong in shared history.])

== Publish The New Project On GitHub

#text(size: 13pt, fill: rgb("#C1C8D0"))[On GitHub, create a New repository with the intended owner, name, and visibility. Leave its README, `.gitignore`, and license unchecked because your local project already has its first commit.]

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Connect GitHub", [#raw("git remote add origin git@github.com:OWNER/REPOSITORY.git", block: true, lang: "bash")]),
  lesson-card("Publish", [#raw("git push -u origin main", block: true, lang: "bash")]),
)

#v(14pt)

#lesson-card("Done", [Refresh the GitHub page to confirm the files and `Initial Commit` appear. Your local folder and GitHub repository are now connected; future work follows status → add → commit → push.])

== Get A Repository And Check Its State

#text(size: 13pt, fill: rgb("#C1C8D0"))[Clone starts a new local copy with its history and remote already configured. Initialize when files already exist on your computer. `git status` is the first command to run whenever you are unsure what Git sees.]

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Clone", [#raw("git clone https://github.com/OWNER/REPOSITORY.git", block: true, lang: "bash")]),
  lesson-card("Inspect", [#raw("git status", block: true, lang: "bash")]),
)

== Choose The Right Start

Use `git clone` when you are starting with a remote repository. Use `git init` when you are starting with a local folder of files, with no existing Git history.

After you have a local repository, the general workflow will be the same for all your work.

== The Everyday Loop

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  row-gutter: 12pt,
  lesson-card("1. Inspect", [Pull the latest work, read the issue, and check your branch status.]),
  lesson-card("2. Change", [Make one focused change. Run the relevant formatter, tests, and build.]),
  lesson-card("3. Stage", [Review the diff, then stage only the intended files.]),
  lesson-card("4. Commit", [Write a concise Conventional Commit that explains the change.]),
  lesson-card("5. Share", [Push the branch and open a pull request with context and evidence.]),
  lesson-card("6. Learn", [Respond to review, update the branch, and capture lessons in documentation.]),
)

== Make A Focused Commit

#text(size: 13pt, fill: rgb("#C1C8D0"))[Review first, stage only the change you intend to save, then create one descriptive checkpoint.]

#v(10pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Review", [#raw("git diff", block: true, lang: "bash")]),
  lesson-card("Stage", [#raw("git add path/to/file", block: true, lang: "bash")]),
  lesson-card("Commit", [#raw("git commit -m \"feat: add sensor validation\"", block: true, lang: "bash")]),
)

== Stage Only What You Intend

Use `git add path/to/file` for an intended file. `git add .` stages every change below the current folder, so inspect `git status` again before committing.

== Sync And Read History

#text(size: 13pt, fill: rgb("#C1C8D0"))[Bring in the team’s changes before sharing yours, then inspect the compact history when you need context.]

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Get Changes from Others", [#raw("git pull", block: true, lang: "bash") or #raw("git fetch && git merge origin/main", block: true, lang: "bash")]),
  [
    #lesson-card("Publish Your Work", [#raw("git push", block: true, lang: "bash")])
    #lesson-card("History", [#raw("git log", block: true, lang: "bash")])
  ]
)

#pagebreak()

#lesson-card("When `pull` Stops", [Git may need you to resolve a conflict if the same lines changed in two places. Read the message, resolve deliberately, and run the relevant checks before continuing.])

#lesson-card("Difference Between `pull` and `fetch`", [
  `git pull` is a shortcut for `git fetch` followed by `git merge`. Use `fetch` when you want to inspect the incoming changes before merging them into your branch. You can inspect unmerged incoming changes with `git log origin/main` or `git diff origin/main`.
])

== Fix Mistakes Safely

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("Before Sharing", [Use the Changes view to discard a mistaken hunk or unstage a file. Check the diff first: discarding is destructive to uncommitted work.]),
  lesson-card("After Sharing", [Use the history view to create a revert commit through the client or a new PR. Leave the correction visible and reviewable.]),
)

#v(14pt)

#lesson-card("Shared History Needs Care", [Do not rewrite a branch that other people are building on. For a shared branch, prefer `git revert` so the correction is explicit and recoverable. Ask before force-pushing.])

= Team Collaboration

== Branches Are Cheap

#text(size: 15pt, fill: rgb("#C1C8D0"))[A branch is a movable name pointing at a line of commits. Create one per focused piece of work.]

#v(16pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Update Main", [In your client, fetch or pull the current `main` branch before starting new work.]),
  lesson-card("Create A Branch", [Use New Branch and choose a short descriptive name such as `fix/default-route` or `feature/dashboard-autosave`.]),
  lesson-card("Publish It", [Push or publish the branch when you are ready to request feedback. The client will associate it with the remote.]),
)

== Branches Visualized

#text(size: 13pt, fill: rgb("#C1C8D0"))[Feature work branches from `main` and merges back when it is ready.]

#v(8pt)

#align(center)[#image("assets/branch-graph.svg", width: 80%)]

#v(2pt)

#text(size: 8pt, fill: rgb("#C1C8D0"))[Keep one branch focused on one question: what change are we making, and how will we know it works?]

== Create, Switch, And Publish A Branch

#text(size: 13pt, fill: rgb("#C1C8D0"))[Start feature work from the current `main` branch. A descriptive branch tells teammates what the work is for before they open a diff.]

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("Create", [Create and move to a new branch: #raw("git switch -c feature/sensor-fix", block: true, lang: "bash")]),
  lesson-card("Switch Existing Branches", [Move between branches you already created: #raw("git switch main\ngit switch feature/sensor-fix", block: true, lang: "bash")]),
)

#pagebreak()

#v(10pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("List Branches", [#raw("git branch -a", block: true, lang: "bash")]),
  lesson-card("Publish", [#raw("git push -u origin feature/sensor-fix", block: true, lang: "bash")]),
)

#v(14pt)

#lesson-card("Before You Switch", [Run `git status` first. Commit, stash, or discard work you do not want to carry over; Git will stop a switch that would overwrite your changes. Use `git switch -` to return to the branch you were on immediately before.])

== Return And Merge When Allowed

#v(10pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Return To Main", [#raw("git switch main", block: true, lang: "bash")]),
  lesson-card("Update It", [#raw("git pull", block: true, lang: "bash")]),
  lesson-card("Merge", [#raw("git merge feature/sensor-fix", block: true, lang: "bash")]),
)

#v(14pt)

#lesson-card("Clean Up", [After a merged branch is no longer needed, delete its local name with `git branch -d feature/sensor-fix`. This does not delete the commits that were merged into `main`.])

#pagebreak()

#v(10pt)

However, at Waterloo Rocketry, we use _*pull requests*_ (PRs) to request review and merge work. A PR is a conversation about a branch of commits, not a single commit. After we review a PR related to the branch, we merge it into `main` and delete the branch. So you mostly will never run `git merge` directly; GitHub does it for you when we merge the PR through the web interface, and you only need to pull the result back to your local repository's `main` branch.

== Collaboration Workflow

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Plan", [Read the issue, confirm scope, and identify acceptance criteria before editing code.]),
  lesson-card("Build", [Use a focused branch. Keep commits small and run relevant checks locally.]),
  lesson-card("Review", [Open a PR/MR with context, evidence, risks, and a link to the issue.]),
)

#v(14pt)

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Discuss", [Treat review comments as collaboration. Ask questions, explain trade-offs, and resolve every thread.]),
  lesson-card("Merge", [Merge only when required checks and approvals are complete. Follow the repository’s merge policy.]),
  lesson-card("Close The Loop", [Link the PR/MR to the issue, verify the result, and update documentation or release notes.]),
)

== Merge Conflicts

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Update Your Branch", [Use Fetch and Update Branch in a GUI, or the branch-sync action in lazygit, before opening or merging a PR.]),
  lesson-card("Resolve The Intent", [Use the client’s conflict editor to read both changes. Build the correct final state; do not blindly choose ours or theirs.]),
  lesson-card("Verify Again", [Conflicts can change behaviour. Re-run the relevant tests and inspect the final diff before marking the conflict resolved.]),
)

= Good SWE Practices

== Clear Naming

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("Commit Messages", [Use Conventional Commits: `type: description`, or `type(scope): description`. For example: `feat: add dashboard autosave`, `fix: correct default route`, or `test: cover LabJack parsing`. Common types are `feat`, `fix`, `docs`, `test`, `refactor`, and `chore`.]),
  lesson-card("Branch Names", [Use `<member>/<convention>/<description>`: `watiam/fix/default-route`, `watiam/feature/dashboard-autosave`, or `watiam/docs/user-guide`. Include an issue number when that helps tracking.]),
)

== Small Changes

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("One Idea Per Change", [When a commit or PR does two unrelated things, split it. Small units are easier to review, test, revert, and explain.]),
  lesson-card("Separate The Noise", [Keep refactors, generated files, formatting sweeps, and unrelated cleanup out of a functional change whenever possible.]),
)

#v(14pt)

#lesson-card("Make Review Easy", [A small PR gives reviewers enough context to reason about behaviour and enough time to check it carefully.])

== Write Clearly

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Problem", [What user or system need does this solve? Link the issue.]),
  lesson-card("Approach", [What changed, and why was this design chosen?]),
  lesson-card("Evidence", [Which tests, screenshots, logs, or manual checks demonstrate the result?]),
)

#v(14pt)

#lesson-card("Call Out Risk", [State migrations, compatibility concerns, follow-up work, or checks you could not run. Clear uncertainty is more useful than hidden uncertainty.])

== Detailed Testing

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("Choose The Right Level", [Unit tests protect small logic; integration tests verify components together; manual checks validate a user-facing flow. Use the smallest set that gives useful confidence.]),
  lesson-card("Test The Edges", [Include failure paths, empty states, invalid inputs, permissions, and recovery behaviour. Bugs often live at the boundary, not the happy path.]),
)

#v(14pt)

#lesson-card("Record What Ran", [In the PR, state the checks you ran and their result. If a check could not run, say why and describe the remaining risk.])

== Document Things

#grid(
  columns: (1fr, 1fr),
  column-gutter: 16pt,
  lesson-card("For Users", [Update setup steps, configuration, behaviour, and limitations whenever the interface changes.]),
  lesson-card("For Maintainers", [Document decisions, invariants, integration points, and non-obvious trade-offs where future contributors will need them.]),
)

#v(14pt)

#lesson-card("Comments Explain Why", [Use comments for constraints and rationale that code cannot express. Do not narrate line-by-line mechanics that the code already makes clear.])

= Hands-On

= Wrap-Up

== Before You Push

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("Scope", [One goal, no accidental generated files, and no secrets.]),
  lesson-card("History", [Clear branch name, focused commits, and an up-to-date base branch.]),
  lesson-card("Evidence", [Formatter, tests, build, screenshots, logs, or a stated limitation.]),
)

#v(14pt)

#lesson-card("Final Check", [Open your client’s status and compare views, then read the PR as if you were reviewing it for the first time.])

== Client Action Cheat Sheet

#grid(
  columns: (1fr, 1fr, 1fr),
  column-gutter: 14pt,
  lesson-card("GitHub Desktop", [Changes for diff and staging; History for commits; Branch for creation and publication; Repository for pull and push.]),
  lesson-card("Tower", [Working Copy for status; History for graph and diff; Branches for creation and merge; Conflict editor for resolution.]),
  lesson-card("lazygit", [Files for staging; Commits for history; Branches for switching; Remotes for synchronization. Press `?` to discover keys.]),
)

== Closing

#text(size: 19pt, weight: "bold", fill: white)[Make history that your teammates can understand.]

#v(18pt)

#lesson-card("The Habit", [Inspect first. Make one focused change. Test it. Commit clearly. Ask for review. Leave the repository easier to work in than you found it.])

#v(18pt)

#text(size: 12pt, fill: rocket-gold)[Questions?]
