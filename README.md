# Adegaflow

Delivery de bebidas com loja para o cliente, pedido por WhatsApp e painel do lojista.
React + TypeScript + Vite + Tailwind CSS, com Supabase (banco, login e imagens).

## Rotas
- `/` loja do cliente
- `/admin` painel do lojista (pedidos, produtos em lista, cupons, bairros, ajustes, abrir/fechar loja)

## Rodar localmente
```bash
npm install
cp .env.example .env   # preencha com a URL e a chave anon do Supabase
npm run dev
```

## Supabase (uma vez)
1. No **SQL Editor**, execute `supabase/01-schema.sql` e depois `supabase/02-upgrade.sql`.
2. Em **Authentication → Users**, crie o usuário administrador (e-mail e senha).
   O login do painel aceita um nome de usuário: `admin` vira `admin@adegaflow.app`,
   então crie o usuário com esse e-mail (ou o e-mail que preferir e digite-o no login).
3. Em **Authentication → Sign In / Providers**, desative o cadastro de novos usuários.

## Publicar no Netlify
- Build command: `npm run build` — Publish directory: `dist` (já em `netlify.toml`).
- Em **Site configuration → Environment variables**, crie:
  - `VITE_SUPABASE_URL`
  - `VITE_SUPABASE_ANON_KEY`
- A chave `anon` é pública por natureza. A proteção dos dados está nas regras RLS do SQL.
  Nunca use a chave `service_role` no front-end.

## Personalizar
- Cores: `tailwind.config.js` (`brand` = verde, `accent` = âmbar).
- Fotos dos produtos: Painel → Produtos → Editar → Enviar imagem.

## Estrutura
```
src/lib        tipos, acesso a dados, utilitários
src/components componentes de interface e carrinho/checkout
src/pages      Shop (loja) e Admin (login + painel)
src/pages/admin  Dashboard, Orders, Products, Coupons, Zones, Settings
supabase/      scripts SQL
```
