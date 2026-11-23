---
name: decide
description: Record a project decision in DECISIONS.md, or check a proposed change against earlier decisions. Use when picking a library or service, changing the data model or architecture, settling how a feature should behave, or before undoing something that was decided earlier.
---

# Decide

Goal: the project remembers *why* things are the way they are, so no session (human or agent) undoes a
good decision by accident or relitigates it every week.

## When to record

- choosing a library, framework, service or hosting;
- changing the data model, auth approach or API shape;
- settling a behaviour question the user answered ("deleted orders are hidden, not removed");
- rejecting an obvious alternative for a reason someone will forget.

Not for: code style, small refactors, anything the code itself makes obvious.

## How to record

Add one line at the **top** of the list in `DECISIONS.md`:

```
- 2026-03-02 — Store uploads in a private bucket with signed URLs — avatars and invoices must not be public.
```

`date — decision — why`. One line. If it needs a paragraph, write the paragraph under the line,
indented. Changing an earlier decision: add a new line that says `replaces <date> <short name>`, and
leave the old line in place.

## Before changing something decided

1. Search `DECISIONS.md` for the area.
2. If your change contradicts a decision, **do not quietly override it**. Tell the user: the old
   decision, why it was made, why you think it should change, what changing it costs.
3. Only after a yes: make the change and record the new decision.
