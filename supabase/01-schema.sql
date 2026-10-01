-- Adega Prime: execute no SQL Editor do Supabase
create table if not exists settings(
  id int primary key default 1 check (id = 1),
  name text not null default 'Adega Prime',
  phone text not null default '5511999999999',
  free_from numeric(10,2) not null default 120,
  city text default 'Entrega em toda a região central',
  pays text[] not null default '{Pix,Cartão de crédito,Cartão de débito,Dinheiro}'
);
create table if not exists zones(
  id uuid primary key default gen_random_uuid(),
  name text not null,
  fee numeric(10,2) not null default 0 check (fee >= 0),
  active boolean not null default true,
  created_at timestamptz default now()
);
create table if not exists products(
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null,
  price numeric(10,2) not null check (price >= 0),
  stock int not null default 0 check (stock >= 0),
  description text default '',
  image_url text,
  active boolean not null default true,
  created_at timestamptz default now()
);
alter table settings enable row level security;
alter table zones enable row level security;
alter table products enable row level security;

create policy "site le configuracoes" on settings for select using (true);
create policy "site le bairros" on zones for select using (active or auth.role() = 'authenticated');
create policy "site le produtos" on products for select using (active or auth.role() = 'authenticated');
create policy "admin altera configuracoes" on settings for all to authenticated using (true) with check (true);
create policy "admin altera bairros" on zones for all to authenticated using (true) with check (true);
create policy "admin altera produtos" on products for all to authenticated using (true) with check (true);

insert into storage.buckets (id, name, public) values ('products', 'products', true) on conflict (id) do nothing;
create policy "imagens publicas" on storage.objects for select using (bucket_id = 'products');
create policy "admin envia imagens" on storage.objects for insert to authenticated with check (bucket_id = 'products');
create policy "admin altera imagens" on storage.objects for update to authenticated using (bucket_id = 'products');
create policy "admin remove imagens" on storage.objects for delete to authenticated using (bucket_id = 'products');

insert into settings (id) values (1) on conflict (id) do nothing;
insert into zones (name, fee) values ('Centro',6),('Jardim América',8),('Vila Nova',10),('Bela Vista',12),('Zona Industrial',15);
insert into products (name, category, price, stock, description) values
('Cerveja Pilsen lata 350ml','Cervejas',3.99,240,'Leve e bem gelada. Preço de caixa com 12 unidades.'),
('IPA Artesanal 500ml','Cervejas',24.90,36,'Amargor equilibrado, notas cítricas.'),
('Chopp Pilsen barril 30L','Cervejas',389,6,'Barril para eventos. Consulte a chopeira.'),
('Vinho tinto Malbec 750ml','Vinhos',79.90,24,'Encorpado, ideal para carnes.'),
('Espumante brut 750ml','Vinhos',64.90,30,'Seco e refrescante para brindar.'),
('Whisky 12 anos 1L','Destilados',169.90,14,'Envelhecido, suave e amadeirado.'),
('Vodka premium 1L','Destilados',89.90,20,'Destilação tripla, base para drinks.'),
('Gin London Dry 750ml','Destilados',119.90,12,'Zimbro em destaque, ótimo com tônica.'),
('Cachaça envelhecida 700ml','Destilados',54.90,18,'Barril de amburana, aroma marcante.'),
('Refrigerante cola 2L','Sem álcool',9.50,80,'Geladinho, fardo com 6 unidades.'),
('Água tônica lata 350ml','Sem álcool',4.50,90,'Perfeita para gin tônica.'),
('Gelo em cubos 5kg','Extras',12,50,'Pacote fechado, feito com água filtrada.');
