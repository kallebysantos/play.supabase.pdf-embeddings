create or replace view "public"."documents_with_storage_path" as  SELECT documents.id,
    documents.storage_object_id,
    documents.status,
    documents.title,
    documents.content,
    documents.created_at,
    documents.updated_at,
    objects.name AS storage_object_path
   FROM (public.documents
     JOIN storage.objects ON ((objects.id = documents.storage_object_id)));

