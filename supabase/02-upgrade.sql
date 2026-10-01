-- Execute DEPOIS do supabase-schema.sql
alter table settings
  add column if not exists tagline text default 'Bebidas geladas com entrega rápida',
  add column if not exists is_open boolean not null default true,
  add column if not exists hours jsonb not null default '{"0":["10:00","23:00"],"1":["10:00","23:00"],"2":["10:00","23:00"],"3":["10:00","23:00"],"4":["10:00","23:00"],"5":["10:00","23:00"],"6":["10:00","23:00"]}',
  add column if not exists min_delivery numeric(10,2) not null default 0,
  add column if not exists min_pickup numeric(10,2) not null default 0,
  add column if not exists pix_key text default '';
alter table products add column if not exists promo_price numeric(10,2) check (promo_price is null or promo_price >= 0);

create table if not exists coupons(
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  kind text not null check (kind in ('percent','fixed')),
  value numeric(10,2) not null check (value > 0),
  min_order numeric(10,2) not null default 0,
  active boolean not null default true,
  created_at timestamptz default now()
);
create table if not exists orders(
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  customer_phone text not null,
  mode text not null,
  zone_name text,
  address text,
  payment text not null,
  change_for text,
  notes text,
  items jsonb not null,
  subtotal numeric(10,2) not null,
  fee numeric(10,2) not null default 0,
  discount numeric(10,2) not null default 0,
  coupon text,
  total numeric(10,2) not null,
  status text not null default 'novo',
  created_at timestamptz default now()
);
alter table coupons enable row level security;
alter table orders enable row level security;
create policy "admin gerencia cupons" on coupons for all to authenticated using (true) with check (true);
create policy "cliente cria pedido" on orders for insert to anon, authenticated with check (status = 'novo');
create policy "admin le pedidos" on orders for select to authenticated using (true);
create policy "admin altera pedidos" on orders for update to authenticated using (true) with check (true);
create policy "admin exclui pedidos" on orders for delete to authenticated using (true);

create or replace function validate_coupon(p_code text)
returns table(code text, kind text, value numeric, min_order numeric)
language sql security definer set search_path = public as $$
  select c.code, c.kind, c.value, c.min_order from coupons c
  where upper(c.code) = upper(p_code) and c.active
$$;
grant execute on function validate_coupon(text) to anon, authenticated;

-- Notificação de novos pedidos em tempo real no painel
alter publication supabase_realtime add table orders;
