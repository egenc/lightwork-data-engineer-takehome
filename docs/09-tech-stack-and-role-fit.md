# Tech Stack and Role Fit (Lead Data Engineer)

## Recommended Production-Oriented Stack

## 1) Core Language and Runtime

- Python 3.12
- FastAPI for ingestion/control APIs
- Polars and Pandas for transformation tasks

Why:

- Matches role requirement for strong Python
- Fast delivery and broad team familiarity

## 2) Data Movement

- Kafka as event backbone
- Airflow for batch scheduling, reconciliation, and backfills

Why:

- Handles both real-time and batch requirements in the JD
- Clear retry and observability model

## 3) Storage

- PostgreSQL for canonical relational entities and AI action audit
- MongoDB for evolving JSON-heavy integration metadata and semi-structured views
- Object storage for raw immutable payloads, media, and replay archives

Why:

- Satisfies relational + NoSQL requirements explicitly
- Keeps canonical model clean while supporting high-change payload shapes

## 4) Retrieval and AI Context

- OpenSearch for operational full-text retrieval
- pgvector in PostgreSQL for initial semantic retrieval
- Qdrant as scale path when vector volume/latency exceed pgvector sweet spot

Why:

- Matches vector DB requirement while remaining cost-aware initially
- Supports agentic workflows that need text + semantic context

## 5) Data Quality, Security, and Governance

- Great Expectations or schema contracts for drift detection
- OpenTelemetry + Prometheus + Grafana for reliability and SLOs
- Tenant-scoped access, PII masking, and immutable model-decision audit logs

Why:

- Directly maps to reliability/security/governance responsibilities

## 6) Deployment

- Kubernetes for all data services
- Horizontal autoscaling by queue lag and processing latency

Why:

- Team already has K8s
- Allows controlled scale-up with isolation boundaries

## Responsibility-to-Stack Mapping

- Scalable pipelines and infrastructure: Kafka + Airflow + Kubernetes
- Ingestion/transformation/storage architecture: Python services + PostgreSQL + MongoDB + object storage
- Batch and real-time pipelines: Airflow DAGs + event consumers
- Vector search and ML data workflows: pgvector/Qdrant + OpenSearch + inference audit tables
- Reliability/security/governance: observability stack + quality contracts + policy gates
- Performance optimization: partitioning, indexing, tiered storage, model routing
- Long-term strategy ownership: ADRs, phased roadmap, scale thresholds

## Scale Triggers for Stack Evolution

- Move pgvector hot sets to Qdrant when P95 semantic retrieval latency exceeds target under expected concurrency
- Introduce Flink when stream stateful joins/windows become complex and consumer logic becomes fragile
- Add warehouse/lakehouse when analytical workloads begin to interfere with operational systems
