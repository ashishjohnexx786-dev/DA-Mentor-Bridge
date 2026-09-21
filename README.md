# Course 2B DA → Data Engineer Bridge 2026 — Mentor edition Astra 2026

Live course: https://ashishjohnexx786-dev.github.io/DA-Mentor-Bridge/

A controlled bridge route: B01–B06, 38 required lessons and six assessment gates. Start with **How to study**, then continue from the first unfinished lesson. The Mentor is the teaching interface: mapped videos/sources, full written lesson text, practice links, progress checks and protected review are kept together.

## Study flow

Watch/read only the mapped source, study the complete written lesson in the Mentor, perform the local engineering task independently, save evidence, then review and retry with changed inputs. At each gate follow A → Review A → different fresh B → Review B. The Mentor records progression; it does not automatically grade your work.

AMOLED and light themes, adjustable reading size, roadmap, protected reviews, browser-local progress, export/restore and a detailed How-to-study guide are included. There is no forced timer. External sources require their original providers. Export progress before clearing browser data or changing devices; phone and PC do not synchronize automatically.

Download the complete current repository from Settings. Read the repository verification/QA markers for native-runtime limits. No generated video lessons are included.

## Repository layout

- index.html, styles.css, app.js: current DE-2026-style Mentor interface.
- curriculum.json and data/: the current 38-lesson bridge route and complete lesson text layer.
- COURSE_MODULES/ and supplements/: canonical bridge books, practice, assessments and supporting material.
- sw.js and manifest.webmanifest: scoped offline caching and app metadata.
- CURRENT_RELEASE.txt / QA files: release and audit markers.

The repository contains one current Course 2B Mentor route. Earlier Mentor versions remain recoverable in Git history. Local progress uses the edition-specific key `course2b-bridge-2026-study-astra-v2`.

The September 21 cache reset uses a repository-scoped service worker. It removes the known legacy Four-Course Mentor caches without touching the protected Standalone DE Mentor 2026 repository or its cache.
