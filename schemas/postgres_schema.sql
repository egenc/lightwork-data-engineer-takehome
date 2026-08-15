-- Core multi-tenant relational schema

create extension if not exists pgcrypto;

create table if not exists tenant (
  tenant_id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now()
);

create table if not exists person (
  person_id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenant(tenant_id),
  full_name text,
  email text,
  phone text,
  pii_hash text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_person_tenant on person(tenant_id);
create index if not exists idx_person_email on person(email);

create table if not exists address (
  address_id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenant(tenant_id),
  street_line_1 text,
  street_line_2 text,
  city text,
  state text,
  postal_code text,
  country_code text,
  created_at timestamptz not null default now()
);

create index if not exists idx_address_tenant on address(tenant_id);

create table if not exists tenancy (
  tenancy_id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenant(tenant_id),
  address_id uuid references address(address_id),
  flat_number text,
  start_date date,
  end_date date,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_tenancy_tenant on tenancy(tenant_id);
create index if not exists idx_tenancy_status on tenancy(status);

create table if not exists household_membership (
  tenant_id uuid not null references tenant(tenant_id),
  tenancy_id uuid not null references tenancy(tenancy_id),
  person_id uuid not null references person(person_id),
  relation_type text,
  is_primary_contact boolean not null default false,
  created_at timestamptz not null default now(),
  primary key (tenancy_id, person_id)
);

create index if not exists idx_household_tenant on household_membership(tenant_id);

create table if not exists source_record_map (
  source_map_id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenant(tenant_id),
  source_system text not null,
  source_entity text not null,
  source_id text not null,
  internal_entity text not null,
  internal_id uuid not null,
  source_updated_at timestamptz,
  raw_payload_uri text,
  ingestion_run_id text,
  created_at timestamptz not null default now(),
  unique (tenant_id, source_system, source_entity, source_id)
);

create index if not exists idx_source_record_lookup
  on source_record_map(tenant_id, source_system, source_entity, source_updated_at);

create table if not exists conversation_thread (
  thread_id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenant(tenant_id),
  person_id uuid references person(person_id),
  tenancy_id uuid references tenancy(tenancy_id),
  channel text not null,
  opened_at timestamptz not null,
  closed_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists idx_thread_tenant on conversation_thread(tenant_id);

create table if not exists communication_event (
  event_id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenant(tenant_id),
  thread_id uuid references conversation_thread(thread_id),
  event_type text not null,
  occurred_at timestamptz not null,
  payload_uri text,
  payload_json jsonb,
  dedupe_key text,
  created_at timestamptz not null default now(),
  unique (tenant_id, dedupe_key)
);

create index if not exists idx_event_tenant_time on communication_event(tenant_id, occurred_at desc);
create index if not exists idx_event_type on communication_event(event_type);

create table if not exists transcript_segment (
  segment_id uuid primary key default gen_random_uuid(),
  event_id uuid not null references communication_event(event_id),
  speaker text,
  start_ms int,
  end_ms int,
  text text not null,
  version int not null default 1,
  created_at timestamptz not null default now()
);

create index if not exists idx_segment_event on transcript_segment(event_id);

create table if not exists ai_inference (
  inference_id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenant(tenant_id),
  event_id uuid not null references communication_event(event_id),
  model_name text not null,
  model_version text not null,
  task_type text not null,
  confidence numeric(5,4),
  output_json jsonb not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_inference_tenant_event on ai_inference(tenant_id, event_id);

create table if not exists recommended_action (
  action_id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references tenant(tenant_id),
  event_id uuid not null references communication_event(event_id),
  inference_id uuid references ai_inference(inference_id),
  action_type text not null,
  reason text,
  priority text,
  status text not null default 'proposed',
  acted_at timestamptz,
  created_at timestamptz not null default now()
);

create index if not exists idx_action_tenant_status on recommended_action(tenant_id, status);
