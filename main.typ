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

// The deck uses a logo-only footer; suppress diatypst's default divider.
#show line: _ => []

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
  agenda-item("02", "Remote Setup & GitHub", "GitHub, remotes, and setup"),
  agenda-item("03", "Git Clients", "CLI, lazygit, and GUI clients"),
  agenda-item("04", "Git Setup & Basics", "Setup, stage, commit, inspect"),
  agenda-item("05", "Team Collaboration", "Branches, merges, PRs, reviews"),
  agenda-item("06", "Hands-On", "Practice the full workflow"),
)

== Good SWE practices

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
