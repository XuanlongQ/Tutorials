# Tutorials
This is `Readme` file for all tutorial materials.

## Description
This folder contains all materials from the courses in which I served as a TA/CA. I typically serve as a TA/CA in the Department of Sociology, Faculty of Social Science.
- I will not take on any TA/CA duties from Spring 2024 to Spring 2026 due to the CSSPFS fellowship.

## Course List
- SOSC 7010/7020 (Seminar: Computational Social Science), CUHK. 2022- Present
- SOCI 3238 (Digital Sociology), CUHK. Fall 2026.
- SOCI 3240 (Social Studies of Science), CUHK. Fall 2023.
- SOCI 3102 (Social Networks and Social Capital), CUHK. Spring 2024.

## Slides
Slides are written in Markdown with [Marp](https://marp.app/) and rendered to HTML + PDF. Students can view the HTML slides on [GitHub Pages](https://xuanlongq.github.io/Tutorials/) or download the PDF from the course folder.

### Structure
- Each deck's source is `slides.md` inside its tutorial folder (e.g. `SOCI 3238/tutorial1/slides.md`).
- Building produces `slides.html` and `slides.pdf` next to the source (both are committed so students can download the PDF and Pages can serve the HTML).
- The slide theme lives in `assets/themes/cuhk.css` (CUHK purple/gold).

### Build
```bash
npm install                # once: installs marp-cli
npm run build:slides       # builds every slides.md in the repo
npm run watch -- "SOCI 3238/tutorial1/slides.md"   # live preview while editing
```
Or use the [Marp for VS Code](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode) extension to preview `slides.md` live inside the editor (the theme is already configured in `.vscode/settings.json`).

### Publishing
- HTML slides are served from this repo via GitHub Pages (Settings → Pages → deploy from the `master` branch, root).
- After `npm run build:slides`, commit and push — the site updates automatically.
- Add each new deck to `index.html` so it shows up on the landing page.

## Others

>[!IMPORTANT]
>  **Please do NOT circulate these slides without permission. They are intended for students’ study use only.**

If you have any concerns regarding the content, please feel free to contact me by email.