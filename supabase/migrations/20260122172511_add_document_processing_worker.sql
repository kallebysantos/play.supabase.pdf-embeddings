set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.trigger_process_document_flow()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
$function$
;

CREATE TRIGGER process_documents_trigger AFTER INSERT ON public.documents REFERENCING NEW TABLE AS new_documents FOR EACH STATEMENT EXECUTE FUNCTION public.trigger_process_document_flow();

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

