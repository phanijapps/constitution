# constitution

**The self-managing software constitution — build it, ground it, maintain it, query it.**

Inspired by [software/constitution™](https://softwareconstitution.com/) (Apache-2.0).
Their standard governs codebases **at CI time**. This project goes further.

## What this is

A constitution is your codebase's law: rules with evidence, counterexamples, and gates.
This project provides the **skill** that builds, grows, and maintains constitutions for
any repository — plus the tooling to keep them honest.

## How this differs from software/constitution™

| | software/constitution™ | **this project** |
|---|---|---|
| **Focus** | CI-time enforcement (gates on push) | Full lifecycle: build → maintain → query → self-manage |
| **Creation** | Copy templates, author by hand | **Skill-driven**: interview (greenfield) or mine code+docs (brownfield) |
| **Knowledge** | Not addressed | **Knowledge packs**: domain-organized, progressively loaded, STE-style |
| **Rules** | Written by humans | **Evidence-grounded**: every rule carries `file:line` evidence, a counterexample, and a gate |
| **Rule catalogue** | Hand-maintained implementation registry | **Derived rule catalogue**: auto-regenerated from rule files; drift = CI failure |
| **Maintenance** | Manual | **Self-managing**: health detects size-law violations, orphans, drift; the system advises, you decide |
| **Search** | Not addressed | **query.py**: find rules/knowledge/runbooks by symptom or concept |
| **Runbooks** | Not addressed | **Versioned procedural knowledge**: scar-born, post-incident checklist enforced |
| **Monorepo** | Not addressed | **Module sub-constitutions**: per-module×concern authority test |
| **Style** | Not addressed | **ASD-STE100 subset**: ≤20-word procedural, ≤25-word descriptive, lintable |
| **Incidents** | Not addressed | **Root-cause index**: counterexamples are pre-written postmortems |

## Quick start

```bash
# Linux/Mac
./install.sh

# Windows PowerShell
.\install.ps1
```

The installer asks you to select your coding agent (a CI workflow template is included at `.github/workflows/constitution.yml` — copy it to your repo and adjust the skill path) (Claude Code, Codex, Cursor, etc.)
and copies the skill to the right location.

## What you get

```
your-repo/docs/constitution/
  00-INDEX.md              project one-pager + universal law
  product/                 what the software promises (knowledge + rules)
  architecture/            how it's built (knowledge + rules + diagrams)
  dev/                     how it's made (knowledge + rules)
  testing/                 what proves it (knowledge + rules)
  ci/                      what runs (enforcement view)
  security/                trust boundaries (knowledge + rules)
  release/                 how it ships (knowledge + rules)
  platform/                where it runs (knowledge + rules)
  registry/                derived catalogue + gates + events + components
```

## The three self-management lanes

| Lane | What runs | Who decides |
|---|---|---|
| **Derived** | Catalogue, manifests regenerated from rule files | Nobody — it's a build artifact |
| **Detect** | Health checks: size law, drift, orphans, uncatalogued rules | The system surfaces findings; the agent advises you |
| **Human** | Rule changes, splits, structural evolution | You ask; the skill drafts with alternatives; you ratify |

## License

Apache-2.0 (matching the inspired standard).

## Credits

- [software/constitution™](https://softwareconstitution.com/) — the CI-time enforcement standard
- [ASD-STE100](https://en.wikipedia.org/wiki/Simplified_Technical_English) — the controlled-language style
- [BCP 14 / RFC 2119](https://www.rfc-editor.org/info/bcp14) — normative keyword semantics
- [EARS](https://en.wikipedia.org/wiki/Easy_Approach_to_Requirements_Syntax) — requirement phrasing
