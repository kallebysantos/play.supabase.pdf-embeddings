-- Handle a new documents and push it to the process queue
create or replace function trigger_process_document_flow()
returns trigger as $$
begin
  perform pgflow.start_flow(
    flow_slug => 'processDocuments',
    input => jsonb_build_object(
      'documentId', new_documents.id
    )
  )
  from new_documents;

  return null;
end;
$$ language plpgsql;

create trigger process_documents_trigger
  after insert on documents
  referencing new table as new_documents
  for each statement
  execute function trigger_process_document_flow();

-- ping edge worker at every minute
select cron.schedule(
  'ping_process_documents_worker',
  '30 seconds',
  $$
    select edge_worker.spawn('process-documents')
  $$
);

select cron.schedule(
  'pgflow-watchdog--process-documents',
  '10 seconds',
  $$
  with secret as (
      select decrypted_secret as supabase_key
      from vault.decrypted_secrets
      where name = 'supabase_publishable_key'
  ),
  settings as (
      select decrypted_secret as supabase_url
      from vault.decrypted_secrets
      where name = 'supabase_url'
  )
  select net.http_post(
    url := (select supabase_url from settings) || '/functions/v1/' || 'process-documents-worker',
    headers := jsonb_build_object('authorization', 'bearer ' || (select supabase_key from secret))
  ) as request_id
  where (
    select count(distinct worker_id) from pgflow.workers
    where function_name = 'process-documents-worker'
      and last_heartbeat_at > now() - make_interval(secs => 6)
  ) < 2;
  $$
);
