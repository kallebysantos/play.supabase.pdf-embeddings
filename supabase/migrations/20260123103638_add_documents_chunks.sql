create sequence "public"."documents_chunks_id_seq";

create table "public"."documents_chunks" (
  "id" bigint not null default nextval('public.documents_chunks_id_seq'::regclass),
  "document_id" uuid,
  "content" text not null,
  "embedding" extensions.halfvec(384)
);


alter sequence "public"."documents_chunks_id_seq" owned by "public"."documents_chunks"."id";

CREATE INDEX documents_chunks_embedding_idx ON public.documents_chunks USING hnsw (embedding extensions.halfvec_ip_ops);

CREATE UNIQUE INDEX documents_chunks_pkey ON public.documents_chunks USING btree (id);

alter table "public"."documents_chunks" add constraint "documents_chunks_pkey" PRIMARY KEY using index "documents_chunks_pkey";

alter table "public"."documents_chunks" add constraint "documents_chunks_document_id_fkey" FOREIGN KEY (document_id) REFERENCES public.documents(id) ON DELETE CASCADE not valid;

alter table "public"."documents_chunks" validate constraint "documents_chunks_document_id_fkey";

grant delete on table "public"."documents_chunks" to "anon";

grant insert on table "public"."documents_chunks" to "anon";

grant references on table "public"."documents_chunks" to "anon";

grant select on table "public"."documents_chunks" to "anon";

grant trigger on table "public"."documents_chunks" to "anon";

grant truncate on table "public"."documents_chunks" to "anon";

grant update on table "public"."documents_chunks" to "anon";

grant delete on table "public"."documents_chunks" to "authenticated";

grant insert on table "public"."documents_chunks" to "authenticated";

grant references on table "public"."documents_chunks" to "authenticated";

grant select on table "public"."documents_chunks" to "authenticated";

grant trigger on table "public"."documents_chunks" to "authenticated";

grant truncate on table "public"."documents_chunks" to "authenticated";

grant update on table "public"."documents_chunks" to "authenticated";

grant delete on table "public"."documents_chunks" to "service_role";

grant insert on table "public"."documents_chunks" to "service_role";

grant references on table "public"."documents_chunks" to "service_role";

grant select on table "public"."documents_chunks" to "service_role";

grant trigger on table "public"."documents_chunks" to "service_role";

grant truncate on table "public"."documents_chunks" to "service_role";

grant update on table "public"."documents_chunks" to "service_role";

