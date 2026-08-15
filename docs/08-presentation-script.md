# Presentation Script (10-12 Minutes)

## 1. Opening (60 sec)

"I designed this for startup reality: small team, sensitive data, and pressure to ship quickly. The architecture intentionally favors reliability and cost control over complexity."

## 2. Problem Decomposition (2 min)

- Two different data shapes: PMS structured records and live unstructured communication
- Two latency profiles: sync/reconcile versus near-real-time decision support
- One common requirement: secure, tenant-scoped context for AI actions

## 3. Architecture Choice (3 min)

- Two-lane design: ingestion lane + streaming lane
- Shared storage foundation: Postgres, object storage, OpenSearch
- Optional components are phase-gated, not mandatory from day one

Talking point:

"I avoid overbuilding. Every new component must solve a current bottleneck, not a hypothetical future one."

## 4. Reliability and Security (2 min)

- Raw-first ingest for replay and audit
- Idempotent upsert boundary to prevent duplicates
- PII policy gates and tenant-scoped retrieval
- Decision logs for all AI tool calls and actions

## 5. AI and Measurement (2 min)

- Retrieval-augmented context from structured + unstructured stores
- Offline + online benchmarking loop
- Quality, safety, latency, and cost tracked together

Talking point:

"A model that is accurate but too slow or too expensive is not production-ready for a startup."

## 6. Scaling Triggers (1-2 min)

- Clear thresholds for queue lag, DB latency, and model cost
- Interventions mapped to each threshold
- Progressive upgrades only when signals justify them

## 7. Close (30 sec)

"This design gives Lightwork a dependable path from MVP to scale, while keeping platform costs and team complexity aligned with startup constraints."
