# Tooling Choices Explained

## Guiding Principle

Pick tools that help us ship quickly, run reliably, and control cost. Avoid complexity unless it solves a real problem we already have.

## Selected Baseline Stack for LightWork

- Language: Python 3.12
- Batch orchestration: Airflow
- Real-time transport: Kafka (managed if possible)
- Stream processing: Python consumers first, Flink only when stateful complexity grows
- Relational store: PostgreSQL
- NoSQL store: MongoDB
- Search and retrieval: OpenSearch
- Vector retrieval: pgvector first, move hot indexes to Qdrant if latency/scale demands
- Low-latency cache and coordination: Redis
- Raw media and payload archive: object storage
- Observability: OpenTelemetry, Prometheus, Grafana

This stack is practical for an early team: it handles both day-to-day product work and AI-heavy workloads, without creating a large operations burden too early.

## Core Toolset

### Kubernetes

Problem solved:

- One consistent way to run and scale all data services

Why it fits:

- Team already has a cluster
- Works well for mixed workloads and autoscaling based on queue lag

Trade-off:

- Adds operational overhead if platform ownership is still light

### Stream Broker (Kafka)

Problem solved:

- Reliable event flow between systems, with replay when needed

Why it fits:

- Necessary for live data and asynchronous processing

Trade-off:

- Extra infrastructure to operate, so a managed option is better at first

### PostgreSQL

Problem solved:

- Trusted source of truth for tenant, tenancy, and action data

Why it fits:

- Mature, cost-effective, and great for transactional workloads

Trade-off:

- Not the best place to keep very large raw event history long term

### Object Storage (S3/GCS/Azure Blob)

Problem solved:

- Low-cost storage for raw files, audio, and transcript snapshots

Why it fits:

- Gives us replay and audit history without inflating database costs

Trade-off:

- Slower than a database for small, record-level lookups

### OpenSearch

Problem solved:

- Fast text search across messages and transcripts

Why it fits:

- Useful for both operations teams and AI context assembly

Trade-off:

- Needs index tuning and lifecycle management to stay cost-efficient

### Redis

Problem solved:

- Very fast cache and short-lived state for real-time paths

Why it fits:

- Reduces repeated reads to PostgreSQL and OpenSearch for hot data
- Useful for rate limiting, idempotency windows, short session context, and distributed locks
- Improves response times for user-facing workflows and AI tool calls

Trade-off:

- Data is typically ephemeral, so Redis should not be used as the source of truth

### Workflow/Orchestration (Temporal, Dagster, Airflow)

Problem solved:

- Reliable scheduling, retries, and visibility for sync and backfill jobs

Why it fits:

- PMS syncing and reconciliation are long-running and need checkpointing

Trade-off:

- Another moving part, so we should pick the tool the team can run confidently

### Data Validation (Great Expectations or custom contracts)

Problem solved:

- Detect source changes and bad records before they break core datasets

Why it fits:

- PMS schemas will change over time, so automatic checks are essential

Trade-off:

- Requires ongoing upkeep as sources evolve

### Observability (OpenTelemetry + Prometheus + Grafana)

Problem solved:

- One place to monitor latency, failures, and cost

Why it fits:

- Critical for running real-time and AI workflows safely at scale

Trade-off:

- Works only if teams instrument services consistently

## Cost-Conscious Deployment Path

1. Start with managed PostgreSQL, managed Kafka, object storage, and one OpenSearch cluster.
2. Add Redis when hot-path latency or repeated query load becomes visible in production.
3. Add autoscaling and table/index partitioning when real traffic justifies it.
4. Add specialized systems (Flink, dedicated vector database, warehouse) only after clear bottlenecks are measured.
