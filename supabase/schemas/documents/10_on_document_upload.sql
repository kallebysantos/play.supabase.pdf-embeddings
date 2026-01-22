-- Handle uploads and create a new document record
create or replace function handle_document_upload()
returns trigger
language plpgsql
security definer
as $$
begin
  insert into documents (
    storage_object_id
  )
  values (
    new.id
  );

  return new;
end;
$$;

create trigger on_document_upload
after insert on storage.objects
for each row
when (new.bucket_id = 'documents')
execute function handle_document_upload();

