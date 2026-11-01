# Writing style (controlled English, mechanically enforced)

Inspired by ASD-STE100 (aerospace controlled English). We enforce the
mechanical, lintable subset; vocabulary purity is human-reviewed.

## Procedural register (rules/<ID>.md, statements)
- One instruction per sentence. Sentences <= 20 words.
- Verb forms: imperative, simple present, infinitive only.
- Active voice. BCP 14 keywords (MUST/SHALL/SHOULD/MAY) carry force.
- Start safety-critical lines with a command or condition.

## Descriptive register (knowledge.md, charters)
- Sentences <= 25 words. One topic per paragraph. <= 6 sentences per paragraph.
- Active voice; passive only when the agent is unknown.
- No multi-word nouns longer than three words.

## Exempt from lint
Tables, code spans, fenced blocks, headings, evidence citations.

## Conversion pass
Run `scripts/lint.py --strict` over the drafted constitution; rewrite flagged
sentences until zero findings. The lint is the style contract.
