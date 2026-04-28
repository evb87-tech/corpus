# Interview — Luc Bernard, Head of DevOps, Mar 2026

**Date:** 2026-03-05
**Interviewer:** Product team
**Duration:** 40 min
**Format:** In-person, notes only (recording declined)

---

## Context

Luc Bernard is Head of DevOps at LogiTrack, a 60-person logistics SaaS. He manages infrastructure for a platform processing ~4M events/day. He is the primary on-call contact for the platform and has been experimenting with custom Zapier/PagerDuty workflows to route alerts. He was referred to us by a mutual contact.

---

## Notes

**On current notification pain:**

> "I get maybe 300 alerts a day. 285 of them are noise. The problem is I can't automate the suppression because the 15 that matter look almost identical to the 285 that don't — until you know the context."

> "The context is: is it a Friday afternoon before a long weekend? Is this service behind a feature flag that's off for 99% of users? Is the person assigned to fix this currently in a meeting? All of that is in my head and nowhere else."

**On AI-powered tools:**

> "I tried one of those AI ops tools last year. Big vendor, big price. It made things worse. It learned from my dismissals and started suppressing alerts that were actually important. The model got too confident too fast. I had to roll it back after two weeks."

> "I don't want AI that learns from my behavior. I want AI that follows my rules. There's a big difference. Rules are auditable. Learning is a black box."

**On what would work:**

> "Give me a rule engine that I can write in plain English and that explains what it did. Like: 'This alert was suppressed because it matched rule: service=payments AND error_rate<0.1% AND time=business-hours.' I'd pay for that tomorrow."

**On team adoption:**

> "My team would use anything I told them to use. That's not the constraint. The constraint is I'd need to justify it to my CISO. And my CISO's first question is always: where does the data go, and who can see it."

**On pricing:**

> "We're 60 people. We're not enterprise. But we're also not a startup — we have real SLAs. I've been burned by 'startup pricing' that tripled after Series B. I'd pay €500/month flat if the product does what it says."

---

## Observations

- Luc's pain is about rule-based control, not AI autonomy — opposite of the "intelligent routing" framing we use internally.
- Strong CISO/security gatekeeper in the purchasing path.
- Negative prior experience with ML-based ops tools shapes his expectations strongly.
- Pricing sensitivity is explicit: flat, predictable, mid-market.
- NOTE: Luc's "I don't want AI that learns" stance directly contradicts Sophie's implicit acceptance of adaptive routing. This tension should be explored in further research.
