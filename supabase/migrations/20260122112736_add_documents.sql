  create table "public"."documents" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "storage_object_id" uuid not null,
    "status" text not null default 'new'::text,
    "title" text,
    "content" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone
      );


CREATE UNIQUE INDEX documents_pkey ON public.documents USING btree (id);

alter table "public"."documents" add constraint "documents_pkey" PRIMARY KEY using index "documents_pkey";

alter table "public"."documents" add constraint "documents_status_check" CHECK ((status = ANY (ARRAY['new'::text, 'processed'::text]))) not valid;

alter table "public"."documents" validate constraint "documents_status_check";

alter table "public"."documents" add constraint "documents_storage_object_id_fkey" FOREIGN KEY (storage_object_id) REFERENCES storage.objects(id) not valid;

alter table "public"."documents" validate constraint "documents_storage_object_id_fkey";

grant delete on table "public"."documents" to "anon";

grant insert on table "public"."documents" to "anon";

grant references on table "public"."documents" to "anon";

grant select on table "public"."documents" to "anon";

grant trigger on table "public"."documents" to "anon";

grant truncate on table "public"."documents" to "anon";

grant update on table "public"."documents" to "anon";

grant delete on table "public"."documents" to "authenticated";

grant insert on table "public"."documents" to "authenticated";

grant references on table "public"."documents" to "authenticated";

grant select on table "public"."documents" to "authenticated";

grant trigger on table "public"."documents" to "authenticated";

grant truncate on table "public"."documents" to "authenticated";

grant update on table "public"."documents" to "authenticated";

grant delete on table "public"."documents" to "service_role";

grant insert on table "public"."documents" to "service_role";

grant references on table "public"."documents" to "service_role";

grant select on table "public"."documents" to "service_role";

grant trigger on table "public"."documents" to "service_role";

grant truncate on table "public"."documents" to "service_role";

grant update on table "public"."documents" to "service_role";

