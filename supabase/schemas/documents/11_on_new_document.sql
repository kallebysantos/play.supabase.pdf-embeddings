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
