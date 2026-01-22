create table if not exists documents (
  id uuid not null primary key default uuid_generate_v4(),
  storage_object_id uuid not null references storage.objects(id),
  status text not null default 'new',
    check (status in ('new', 'processed')),
  -- Processed fields
  title text,
  content text,
  -- System fields
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

