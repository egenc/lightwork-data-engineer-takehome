# Budget-Aware Rollout Plan

## Goal

Deliver measurable value in 90 days with minimal platform overhead.

## Phase 0 (Week 1-2): Foundations

- Define canonical schema and source contracts
- Set up managed PostgreSQL + MongoDB + object storage + Kafka
- Implement core observability (ingest lag, error rate, processing latency)

Success criteria:

- One source can ingest and upsert with idempotency
- Replay from raw payload is functional

## Phase 1 (Week 3-6): Ingestion MVP

- Modern PMS connector + one legacy adapter
- DLQ and replay tooling
- Airflow DAGs for scheduled sync and reconciliation
- Data quality checks for required fields and schema drift

Success criteria:

- 99% successful ingest for known-good records
- Backfill and reconciliation runbooks validated

## Phase 2 (Week 7-10): Real-Time + AI MVP

- Message/transcript event pipeline
- AI classification and recommendation in shadow mode
- OpenSearch index for operational retrieval
- pgvector retrieval for AI context augmentation

Success criteria:

- P95 classification latency under target (P95 (95th percentile): 95% of requests are faster than this value, and 5% are slower on how long AI classifier takes to return a result)
- Action recommendation quality beats baseline heuristics

## Phase 3 (Week 11-13): Production Hardening

- HPA tuning by queue lag
- Tenant-level throttling and isolation
- Benchmark dashboard with model quality and cost
- Decision gate for Qdrant adoption based on vector latency and corpus growth

Success criteria:

- Stable under synthetic peak load
- No critical PII incidents in logs/prompts

## Cost Controls

- Prefer managed services over self-hosting in early phase
- Keep raw data in object storage; avoid expensive hot retention in DB
- Tier models by task criticality and complexity
- Use autoscaling and pause non-critical workers off peak
