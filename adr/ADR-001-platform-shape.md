# ADR-001: Platform Shape for Startup Stage

## Status

Accepted

## Context

Lightwork needs a secure and scalable platform for:

- PMS data ingestion (legacy and modern APIs)
- Real-time communication processing
- Agentic AI workflows

Constraints:

- Small team
- Cost sensitivity
- High reliability requirements for tenant-facing operations

## Decision

Adopt a two-lane architecture:

- Ingestion lane for PMS synchronization
- Streaming lane for live communication events

Shared storage foundation:

- PostgreSQL for canonical entities and operational decisions
- Object storage for immutable raw artifacts
- OpenSearch for text retrieval
- Optional vector retrieval as phase-2+

Deploy workloads on Kubernetes with autoscaling based on queue lag and latency.

## Consequences

Positive:

- Fast delivery using mostly mature components
- Strong auditability and replay support
- Flexible AI context retrieval strategy

Negative:

- Multiple storage systems increase operational burden
- Requires disciplined schema governance and observability

## Alternatives Considered

- Monolithic DB-only solution: simpler but weak for high-volume unstructured retrieval
- Full lakehouse first: powerful but too heavy for early-stage execution
- Serverless-only event stack: can be efficient but may complicate local reasoning and portability
