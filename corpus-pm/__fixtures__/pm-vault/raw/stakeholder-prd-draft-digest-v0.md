# [DRAFT v0] PRD — Smart Digest Feature
## From: Antoine Lefebvre, VP Product | To: Product team | Date: 2026-03-20

> Note: This is a v0 stakeholder brief, not a finalized PRD. It represents the VP's initial framing and should be refined with user research.

---

## Background

Q1 user interviews revealed that our most requested missing feature is some form of notification digest — a periodic rollup of non-urgent messages so users don't have to manually triage hundreds of Slack/Teams messages per day.

Several enterprise prospects have specifically asked for this as a prerequisite to buying.

## Proposed Feature: Smart Digest

**One-line pitch:** A configurable, severity-aware digest that batches non-critical notifications into scheduled summaries, leaving the critical path unaffected.

## Problem (as I understand it)

Our users (primarily engineering managers and DevOps leads) are drowning in low-priority notifications. They've told us they want the noise batched so they can focus on incidents. Today, routing handles the critical path, but everything else — status updates, comments, non-urgent deploys — lands in real-time and creates cognitive overload.

## Proposed Solution

- Users configure "digest windows" (e.g., 9am, 1pm, 5pm).
- Any notification below a configurable severity threshold goes into the digest queue instead of real-time delivery.
- At digest time, an AI summary groups related items and surfaces the 3-5 most important.
- Critical notifications bypass the digest entirely (always real-time).

## Target Personas

- Engineering Manager (Sophie-type): wants team-level digest, configurable by squad.
- DevOps Lead (Luc-type): wants to set severity thresholds himself, not have AI decide.

## Success Metrics

- 60% of active teams configure at least one digest window in the first 30 days.
- Reduction in "real-time" notification volume by 40% (as measured by delivery telemetry).
- NPS improvement of +8 points among users who activate digest.

## Open Questions

1. Should AI summarization be opt-in or opt-out? (I lean opt-in given our persona research.)
2. How does digest interact with on-call rotation — does on-call bypass digest entirely?
3. Pricing: is digest part of the base plan or an add-on?
4. What's the right digest frequency minimum? I assume 2/day but no data.

## What I'm NOT proposing

- A full-blown AI summary with "importance scores" surfaced to the user. That's too opaque for our personas.
- A separate digest product. This should be part of the existing routing rules engine.

## Risks

- **Personalization creep:** If we let users configure too much, the feature becomes unmanageable. We should start with simple frequency + threshold.
- **Privacy:** Digest content should never be stored longer than 24h. Legal review needed before launch.
- **False urgency bypass:** Users might route everything as "critical" to bypass the digest. We need rate limiting or a "boy who cried wolf" detection.
