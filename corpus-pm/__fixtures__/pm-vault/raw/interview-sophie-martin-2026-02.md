# Interview — Sophie Martin, Engineering Manager, Feb 2026

**Date:** 2026-02-14
**Interviewer:** Product team
**Duration:** 55 min
**Format:** Video call, recorded

---

## Context

Sophie Martin is an engineering manager at MedConnect, a 200-person health-tech scale-up. She manages a cross-functional squad of 8 engineers and coordinates across 3 other squads. They currently use Slack, Jira, PagerDuty, and GitHub. Notification overload has been flagged as a recurring pain in her last four quarterly retros.

---

## Transcript (excerpts)

**Q: Walk me through a typical morning.**

> "I open Slack and there's always somewhere between 80 and 200 unread messages. I've learned to just not look at it before 9:30 because if I do, I'm already in firefighting mode before the day starts. But I feel guilty about that — what if there's a real incident?"

**Q: How do you decide what's urgent vs. what can wait?**

> "Honestly? I've built muscle memory. I know that anything from our on-call channel is urgent. I know that anything from the #general channel can wait until end of day. But that's all in my head. New team members have no idea. They escalate everything or miss everything — there's no middle ground for the first three months."

**Q: Have you tried any tools to manage this?**

> "We tried a Slack bot that summarized channels. It was... fine. But it summarized everything at the same level. An incident alert and a birthday message got the same treatment. That's when I gave up on AI summaries. They don't understand context."

> "What I actually want is something that knows the *difference* between a P1 incident and someone asking where the coffee is. Not because I can't figure it out — I can — but because I want my team to have that clarity too, without needing 3 months of ramp-up time."

**Q: If a tool could do one thing perfectly, what would it be?**

> "Route the right notification to the right person at the right time. That's it. I don't need a dashboard. I don't need analytics. I just need to know that if a critical alert fires at 2am, the right person gets woken up — and only that person. Not the whole team."

**Q: What would make you trust such a tool?**

> "Auditability. I need to see a log: this alert came in, it was classified as P1, it was routed to Jean because he's on-call this week. If I can see that reasoning, I trust it. If it's a black box — no."

**Q: What about privacy concerns with routing decisions being AI-assisted?**

> "That's real. We had a conversation with legal about this six months ago. Anything that touches who gets woken up at 2am is sensitive. People have accommodations, stress leave, all sorts. A system that doesn't respect that... that's an HR issue, not just a product issue."

---

## Observations

- Sophie has a clear mental model of urgency but it's not documented anywhere.
- Strong preference for auditability over automation.
- Privacy concerns around on-call routing are a blocker she'd escalate.
- Team onboarding is a secondary but real pain — the knowledge gap around notification triage.
