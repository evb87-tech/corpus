# Anti-lissage — preserve the singular voice

The wiki must remain a **faithful mirror of what the owner has read**, not a polished average. Three native LLM behaviors silently destroy this property. Suppress them.

## 1. Never harmonize contradictions

A LLM's default pull is to write smooth, consistent prose. When two sources disagree, the model wants to pick one and present it as consensus.

**Forbidden:** rewriting a contested thesis as if it were settled.
**Required:** record both claims, attribute each to its source, and put the conflict under `## Contradictions`.

## 2. Never invent a source

Hallucination is low-probability with a tight context, but not zero. A claim attributed to a source that doesn't exist in `raw/` is a lie, no matter how plausible.

**Forbidden:** writing "according to source X" when no file in `raw/` is the basis.
**Required:** every claim in `wiki/` traces to a file actually present in `raw/`. If you cannot trace it, you cannot write it.

## 3. Never complete with outside knowledge

The model knows things the owner has not read. Injecting that knowledge into `wiki/` silently makes the wiki stop being the owner's reading record. It becomes generic knowledge.

**Forbidden:** filling gaps with training-data facts during ingestion or query response.
**Required:** if the wiki is silent, say so. The owner can choose to drop a source into `raw/` and re-ingest. Pulling from training data is allowed **only when the owner explicitly asks** and the result must be marked `[unverified]` and live in `output/`, never `wiki/`.

## 4. Never smooth the owner's voice

When sources in `raw/` are authored by the owner (personal notes, takeaways, positions), the owner's specific phrasing **is the value**. A polished, averaged paraphrase erases the singular angle.

**Forbidden:** replacing "ce pattern court le risque de devenir un fétiche" with "this pattern carries some risk of over-application."
**Required:** quote verbatim or paraphrase minimally. Mark verbatim quotes with quotation marks and cite the raw source.

## 5. Never produce `type: synthesis` as wiki

A synthesis across multiple sources, written as if it were the owner's own conclusion, is a statistical average dressed up as a position. It does not belong in the wiki.

**Forbidden:** filing back synthesis-posture answers as wiki pages.
**Required:** synthesis lives in `output/`, flagged as a statistical average. See `08-query-postures.md`.

## Why this matters

The wiki's value is *not* that it holds knowledge — search engines do that. Its value is that it holds **what the owner has read, in the owner's order, with the owner's contradictions preserved**. Every smoothing operation degrades that value. The agent's job is to resist its own native pull toward consistency.
