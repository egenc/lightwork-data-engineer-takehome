# 2) Real-Time Processing for Messages, Audio, and Transcripts

## What We Are Solving

We need to process incoming communication events with occasional real-time action requirements.

Examples:

- Urgent maintenance intent in a tenant message
- Escalation signals in call transcripts
- Fraud/abuse or safety-related language

## Streaming Design

Use event-driven processing with topic partitioning by tenant.

Core components:

- Ingestion gateway (webhooks, websocket, upload API)
- Stream broker (Kafka/Redpanda/PubSub equivalent)
- Stateful processors for enrichment and policy
- Online stores for serving and search

## Event Types

- message.received
- audio.received
- transcript.partial
- transcript.final
- ai.classification.updated
- ai.action.recommended
- action.executed

## Processing Stages

1. Ingest event and assign global event_id
2. Validate schema and attach tenant identity
3. Apply PII and policy filters
4. Enrich with context from PMS entities and historical interactions
5. Run AI classification/summarization/action recommendation
6. Persist to serving stores and emit downstream events

## Storage Strategy

### PostgreSQL (operational + canonical)

- Current-state entities
- Action records and decision audits
- Tenant-scoped relational queries

### Object Storage

- Raw message payload snapshots
- Audio files and transcript versions
- Immutable event archives for replay

### OpenSearch

- Full-text retrieval over message and transcript content
- Fast filtering by tenant, urgency, date, channel

### Redis (Hot Path Acceleration)

- Cache recent thread context and high-frequency lookups
- Hold short-lived counters and rate-limit keys
- Support transient coordination state for real-time workers

### Optional Vector Store

- Embedding-based semantic retrieval for AI agents
- Useful once prompt-context quality becomes bottleneck

## Retrieval Patterns

- By tenancy/person key for operational workflows
- By conversational thread and time window for incident review
- By semantic similarity for AI context assembly
- By action/outcome for model feedback loops

## Candidate Schema (Conceptual)

- `conversation_thread(tenant_id, thread_id, channel, opened_at, closed_at)`
- `communication_event(event_id, tenant_id, thread_id, type, occurred_at, payload_uri)`
- `transcript_segment(segment_id, event_id, speaker, start_ms, end_ms, text, version)`
- `ai_inference(inference_id, event_id, model_name, model_version, task, output_json, confidence)`
- `recommended_action(action_id, event_id, reason, priority, status, acted_at)`

See `schemas/postgres_schema.sql` for concrete DDL.

## Real-Time Action Latency Targets

- P95 ingest-to-classification: under 3 seconds
- P95 ingest-to-recommended-action: under 8 seconds
- P99 durable write acknowledgment: under 2 seconds

These are initial targets, not contractual SLOs.
