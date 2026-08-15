# Requirements and Assumptions

## Problem Framing

Lightwork needs a platform that can:

- Ingest tenant and tenancy data from multiple PMS systems
- Process live communication data (messages, audio, transcripts)
- Enable agentic AI workflows that combine live context with historical records
- Scale without premature over-engineering

## Assumptions

- Tenant data is highly sensitive and must be treated as regulated personal data
- PMS integrations vary significantly in API quality and consistency
- Some partners provide webhooks; others only allow polling
- Product actions may require near-real-time responses (seconds to low minutes)
- Team size is small, so operational simplicity is a top-level constraint

## Non-Goals (Initial Phase)

- Not building a full enterprise data mesh
- Not requiring exactly-once processing across every component
- Not introducing expensive distributed systems before real demand exists

## Key Quality Attributes

- Reliability: no silent data loss
- Traceability: full lineage from source payload to internal record
- Recoverability: re-run/replay without corruption
- Latency control: support both batch and low-latency paths
- Cost efficiency: avoid infrastructure that needs full-time platform specialists

## Risks to Manage Early

- Schema drift from PMS APIs
- Duplicate records from retries and overlapping polls
- PII leakage in logs, prompts, or analytics views
- Model hallucination when context retrieval is weak
- Hot partitioning when one tenant has much higher volume
