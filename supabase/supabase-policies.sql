-- Permissões de leitura pública da loja (execute no SQL Editor do Supabase).
-- Sem estas políticas o RLS bloqueia a leitura com a chave anon: a API devolve
-- listas vazias (sem erro) e a loja mostra "Nenhum produto encontrado".
-- Pode ser executado várias vezes com segurança.

alter table products enable row level security;
alter table settings enable row level security;
alter table zones enable row level security;

-- Leitura pública (clientes da loja)
drop policy if exists "publico le produtos" on products;
create policy "publico le produtos" on products for select to anon, authenticated using (true);

drop policy if exists "publico le configuracoes" on settings;
create policy "publico le configuracoes" on settings for select to anon, authenticated using (true);

drop policy if exists "publico le bairros" on zones;
create policy "publico le bairros" on zones for select to anon, authenticated using (true);

-- Gerenciamento pelo lojista logado (painel #admin)
drop policy if exists "admin gerencia produtos" on products;
create policy "admin gerencia produtos" on products for all to authenticated using (true) with check (true);

drop policy if exists "admin gerencia configuracoes" on settings;
create policy "admin gerencia configuracoes" on settings for all to authenticated using (true) with check (true);

drop policy if exists "admin gerencia bairros" on zones;
create policy "admin gerencia bairros" on zones for all to authenticated using (true) with check (true);

grant select on products, settings, zones to anon;
grant select, insert, update, delete on products, settings, zones to authenticated;

-- Garante a linha de configurações usada pela loja (id = 1)
insert into settings (id, name) values (1, 'Adega') on conflict (id) do nothing;
