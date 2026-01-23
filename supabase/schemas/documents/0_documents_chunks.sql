create table documents_chunks (
  id bigserial primary key,
  document_id uuid references documents(id) on delete cascade,
  content text not null,
  embedding extensions.halfvec(384) -- f16 quantinization
);

 -- f16 quantinization
create index on documents_chunks using hnsw (embedding halfvec_ip_ops);
