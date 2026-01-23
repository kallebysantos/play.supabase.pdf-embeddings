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

