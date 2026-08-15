# 4) Scaling Strategy and Intervention Thresholds

## Scaling Philosophy

Scale in layers, only when observed load or reliability metrics justify it.

## Scale Dimensions

- Event throughput (events/sec)
- Storage growth (GB/day, object count)
- Query latency under concurrent load
- AI inference concurrency and cost

## Intervention Triggers

### Ingestion

- Queue lag sustained above 5 minutes for more than 15 minutes
- Connector error rate above 2% for more than 10 minutes

Interventions:

- Increase consumer replicas
- Increase partition count for hot topics
- Isolate noisy or failing connectors into separate pools

### Storage and Query

- PostgreSQL P95 query latency above 300 ms on critical paths
- Write IOPS above 70% sustained utilization

Interventions:

- Add read replicas
- Add Redis cache for repeated hot-path reads and short-lived state
- Partition high-volume event tables by date and tenant hash
- Move cold event payloads from DB to object storage references only

### Search

- OpenSearch P95 query latency above 500 ms
- Indexing backlog above 10 minutes

Interventions:

- Increase shards carefully (avoid oversharding)
- Separate indexing and query node roles
- Introduce ILM tiers for hot-warm-cold data

### AI

- P95 model response above SLA target
- Cost per resolved issue exceeds budget guardrail

Interventions:

- Route low-risk tasks to smaller models
- Introduce batching and caching for repeated retrieval contexts
- Add distilled models for narrow tasks (classification/routing)

## When to Move Beyond Current Stack

- If stream complexity grows (window joins, heavy state), evaluate Flink
- If analytics workload dominates, add warehouse/lakehouse
- If semantic retrieval quality plateaus, adopt specialized vector infra

## Operational Baseline

- End-to-end tracing for every event path
- Dashboard: lag, error rate, latency, cost, model quality
- On-call runbooks for replay, backfill, and rollback
- Monthly load tests and chaos drills for top failure modes
