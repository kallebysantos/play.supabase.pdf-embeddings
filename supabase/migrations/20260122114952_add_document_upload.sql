set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_document_upload()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  insert into documents (
    storage_object_id
  )
  values (
    new.id
  );

  return new;
end;
$function$
;

CREATE TRIGGER on_document_upload AFTER INSERT ON storage.objects FOR EACH ROW WHEN ((new.bucket_id = 'documents'::text)) EXECUTE FUNCTION public.handle_document_upload();


