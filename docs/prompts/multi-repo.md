# Multi-repo constitution prompt

Copy-paste into any coding agent with the constitution skill installed.

---

Build a multi-repo constitution for this workspace.

I have a main repository and N cloned repositories under repos/.
Follow the monorepo module pattern from the constitution skill.

Step 1 — Classify every repo.
For each repo under repos/, apply the decision-authority test:
- If I own its changes and ratify its rules → it's a MODULE (gets a sub-constitution)
- If I consume its releases and never change its code → it's an EXTERNAL
  (declare it in the components registry, no sub-constitution)
List your classification with reasoning before proceeding.

Step 2 — Scaffold the root.
Create the root constitution in this repo with all 8 default packs.
Mine this repo's code, tests, CI workflows, and docs.
Show me every doc-vs-code discrepancy you find.

Step 3 — Create module sub-constitutions.
For each repo classified as a MODULE:
  scaffold it with --module <name>
  Only give it the packs where it holds its own authority:
  - A service with its own deploy → product, architecture, platform, release
  - A shared library → no sub-constitution (root law covers it)
  - A frontend app → product, architecture (shares platform with root)

Step 4 — Cross-reference.
Module rules MUST `refine:` root rules. Root architecture owns the module
boundary map — who may import/call whom. No module defines another module's
internals.

Step 5 — Derive and validate.
Run derive_catalogue --write across root and all modules.
Run health check. Report findings.
Run validate on every constitution tree.

Step 6 — Read back.
Show me:
- The root 00-INDEX.md with the module registry table
- One module's 00-INDEX.md as a sample
- The total rule count across all constitutions
- Any size-law findings or drift
- The external repos declared in the components registry

I will ratify or request changes. Nothing is law until I approve.
