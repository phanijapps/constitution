# The Self-Managing Software Constitution Specification

**Version:** 1.0 · **Status:** Draft · **License:** Apache-2.0
**Home:** [constitution on GitHub Pages](https://phanijapps.github.io/constitution/)
**Inspired by:** [software/constitution™](https://softwareconstitution.com/) (Apache-2.0)

---

## Abstract

A **self-managing software constitution** is a versioned, machine-readable set of
rules, knowledge, runbooks, and registries that a coding agent builds from evidence,
maintains through detection, and evolves through owner ratification. This document
specifies the required artifacts, the three self-management lanes, the domain pack
structure, and the progressive-loading contract.

This extends the software/constitution™ standard (which governs CI-time enforcement)
with: evidence-grounded rule authoring, knowledge compartmentalization, runbook
versioning, a derived registry (never hand-edited), health detection, symptom-based
query, and module sub-constitutions for monorepos.

---

## 1. Required artifacts

| # | Path (relative to repo root) | Purpose |
|---|---|---|
| 1.1 | `docs/constitution/00-INDEX.md` | Master index: project one-pager, universal rules, pack registry, amendment record |
| 1.2 | `docs/constitution/<pack>/00-INDEX.md` | Pack charter, rule table, deviations (one per domain pack) |
| 1.3 | `docs/constitution/<pack>/knowledge.md` or `knowledge/` | Domain knowledge (descriptive STE register); split required when >3,000 tokens (see §4.1) |
| 1.4 | `docs/constitution/<pack>/rules/<RULE-ID>.md` | One rule per file: statement (procedural STE), refs, evidence, counterexample |
| 1.5 | `docs/constitution/<pack>/runbooks/<RB-ID>.md` | Versioned procedural documents (optional per pack; mandatory after first incident in the domain) |
| 1.6 | `docs/constitution/registry/constitution-catalogue.json` | **Derived** catalogue: rule-ID → pack → path → enforcement (never hand-edited) |
| 1.7 | `docs/constitution/DEVIATIONS.md` | Time-boxed exceptions; Active section MUST be empty by default |
| 1.8 | `docs/constitution/DECAY-WINDOWS.md` | Measured debt baselines with closure dates |

## 2. Domain packs

The default cut is eight packs. A project MAY merge or split packs using the
**decision-authority test**: a domain earns its own pack when it has its own
decisions, its own evidence sources, and its own blast radius.

| Pack | Prefix | Owns |
|---|---|---|
| product | PRD | What the software promises: scope, observable outcomes, what it is NOT |
| architecture | ARC | How it is structured: seams, boundaries, component coherence |
| dev | DEV | How artifacts are made: toolchain, builds, reproducibility |
| testing | TST | What proves it: fixtures, coverage discipline, merge safety |
| ci | CIE | Enforcement view: which gate enforces which rule — owns NO other pack's rules |
| security | SEC | Trust boundaries: authz, supply chain, audit |
| release | REL | Shipping: versioning, compatibility, publication, rollback |
| platform | PLT | Where it runs: environments, databases, dependent services |

## 3. Rule format

Every rule MUST satisfy these properties:

1. **False-elsewhere test**: the rule MUST be false for a different codebase.
2. **Evidence**: `file:line` citation (brownfield) or owner-intent marker (greenfield).
3. **Counterexample**: the concrete change that would violate this rule. No counterexample, no rule.
4. **Enforcement honesty**: gate-enforced, review-enforced, or advisory — stated, never smoothed.
5. **STE procedural register**: ≤20 words per sentence, one instruction per sentence, active voice.
6. **BCP 14 keywords**: MUST/MUST NOT/SHALL/SHOULD/MAY carry normative force.
7. **Typed references**: `governs:` (authority), `refines:` (local narrowing), `enforced-by:` (gate), `see:` (information).

## 4. Knowledge format

Knowledge is descriptive (not procedural) and follows the **ASD-STE100 descriptive
register**: ≤25 words per sentence, one topic per paragraph, ≤6 sentences per paragraph.

### 4.1 Size law

| Condition | Requirement |
|---|---|
| ≤2,400 tokens (estimated) | Monolithic `knowledge.md` permitted |
| ≥2,400 tokens (estimated) | **Advisory finding**: split recommended |
| >3,000 tokens (estimated) | **Blocking failure**: split required |

Split knowledge lives in `knowledge/` with an `INDEX.md` manifest.

### 4.2 Manifest contract

The manifest MUST record per fragment: purpose, token estimate, **prerequisites**
(companion fragments that MUST co-load), and **task routes** (which agent stage loads it).
The manifest MUST declare one **full-read route** (all fragments in order).

An agent following a task route MUST NOT omit a declared prerequisite.

## 5. Runbook format

Runbooks are procedural documents for diagnosing and mitigating known failure modes.

Required sections: Trigger, Blast radius, Steps (numbered, imperative), If steps don't
resolve (escalation), Post-incident checklist (mandatory), Change log (versioned).

Runbooks MUST be updated after every incident that uses them (what actually worked).
The post-incident checklist enforces this.

## 6. The three self-management lanes

### 6.1 Lane 1 — Derived (automation executes, no approval)

The catalogue is regenerated from rule files on every push. The gate proves the
committed catalogue matches the derivation. Humans never hand-edit the registry.

### 6.2 Lane 2 — Detect and advise (automation surfaces, the owner decides)

Health checks detect: size-law crossings, orphan knowledge fragments, uncatalogued
rules, incomplete packs, undeclared modules. Findings surface in CI and in the agent's
session context. The agent advises the owner with evidence — **never a drafted diff**.

### 6.3 Lane 3 — Human-originated (the skill drafts only when asked)

Structural changes (splits, new rules, pack merges) require owner origination.
The skill drafts with rejected alternatives listed. Structural changes require
verified authorization: an L3 ratification bound to the exact revision, or a signed
owner instruction. The gate classifies changes from the diff, not the commit message.

## 7. Module sub-constitutions (monorepo)

A module earns a sub-constitution at `docs/constitution/modules/<name>/` when it
holds its own decision authority for a given concern. The per-module×concern test:

| Module type | Owns | Shares root |
|---|---|---|
| Microservice (own deploy) | product, architecture, platform, release | dev, testing, ci, security |
| Monolith module | product rules only | almost everything |
| Shared library | nothing | everything |

Root architecture owns module boundaries, never module internals.

## 8. Query (search)

The constitution MUST be searchable by symptom, concept, or rule ID. The query tool
returns: matching rules (from the derived catalogue), knowledge fragments (from
manifests, with prerequisites), and runbooks (by trigger). Results are sized for
progressive loading.

## 9. Root-cause identification

Counterexamples serve as pre-written incident postmortems. When an incident's symptoms
match a rule's counterexample, the rule's evidence citation narrows the code search to
the cited files. A no-match result signals either a novel failure or a missing rule —
both actionable.

## 10. Relationship to software/constitution™

This specification is inspired by the software/constitution™ standard but is a
separate spec. Upstream conformance is NOT implied — upstream requires six rule
classes (zero competing systems, repo↔prod drift, production stubs, canonical
events, zero deviation, no orphans) that this spec does not enforce. Projects
may satisfy both, but must map the six classes separately.

---

**End of v1.0 (Draft).** Feedback: [GitHub Issues](https://github.com/phanijapps/constitution/issues).
