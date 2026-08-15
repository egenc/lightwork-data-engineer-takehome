# 3) Agentic AI Data Usage and Benchmarking

## What We Are Solving

Agentic AI should combine:

- Live communication signals
- Historical PMS and tenancy context
- Prior interaction outcomes

to produce safe, useful recommendations and automated actions.

## Data Usage Pattern

### Retrieval-Augmented Context

At inference time, compose context from:

- Tenant and tenancy profile (structured)
- Recent thread and transcript excerpts (unstructured)
- Prior actions and outcomes
- Policy constraints and tool permissions

### Agent Tooling Contract

Agent runtime can call:

- `get_tenancy_context(tenant_id, person_id, tenancy_id)`
- `search_transcripts(tenant_id, query, window)`
- `propose_action(event_id, action_type, rationale)`
- `log_decision(event_id, model_version, confidence)`

All tool calls are audited.

## Guardrails

- Strict tenant scoping for every retrieval call
- PII masking in prompts when full values are unnecessary
- Action policy checks before execution
- Human-in-the-loop for high-risk actions

## Benchmarking Framework

### Offline Evaluation

Datasets:

- Labeled historical communication events
- Action outcome labels (correct, escalated, reversed)
- Diverse tenant slices to avoid narrow optimization

Metrics:

- Classification: precision, recall, F1 by label
- Recommendation ranking: NDCG@k, MRR
- Hallucination proxy: unsupported claim rate
- Safety: policy violation rate
- Cost: average token and compute cost per event

### Online Evaluation

- Shadow mode before active interventions
- A/B or interleaving tests for model versions
- Track resolution time, escalation rate, and user satisfaction proxies

### Operational Model KPIs

- P95 model latency
- P99 end-to-end workflow latency
- Action acceptance rate by human operators
- Drift indicators by source/channel/tenant segment

## Feedback Loop

1. Capture model output and downstream outcomes
2. Join outcomes back to inference IDs
3. Build error slices and failure taxonomies
4. Retrain or prompt-tune with targeted data
5. Re-evaluate on fixed benchmark set

This creates a measurable improvement cycle instead of ad hoc prompt editing.
