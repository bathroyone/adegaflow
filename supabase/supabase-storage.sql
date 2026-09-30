-- Bucket público para as imagens dos produtos (usado no upload do painel admin)
insert into storage.buckets (id, name, public)
values ('products', 'products', true)
on conflict (id) do update set public = true;

drop policy if exists "imagens produtos leitura publica" on storage.objects;
create policy "imagens produtos leitura publica" on storage.objects
  for select to anon, authenticated using (bucket_id = 'products');

drop policy if exists "admin envia imagens produtos" on storage.objects;
create policy "admin envia imagens produtos" on storage.objects
  for insert to authenticated with check (bucket_id = 'products');

drop policy if exists "admin altera imagens produtos" on storage.objects;
create policy "admin altera imagens produtos" on storage.objects
  for update to authenticated using (bucket_id = 'products') with check (bucket_id = 'products');

drop policy if exists "admin exclui imagens produtos" on storage.objects;
create policy "admin exclui imagens produtos" on storage.objects
  for delete to authenticated using (bucket_id = 'products');
