# Sistema de E-commerce - Backend Supabase

Backend completo para sistema de e-commerce desenvolvido com Supabase, incluindo autenticação, RLS, funções automatizadas e Edge Functions.

## 🚀 Funcionalidades Implementadas

- ✅ Tabelas para clientes, produtos e pedidos
- ✅ Row-Level Security (RLS) completo
- ❌ Funções no banco de dados para automação
- ❌ Views para consultas otimizadas
- ❌ Edge Functions para e-mail e exportação CSV

## 📋 Pré-requisitos

- Node.js 18+
- Conta no Supabase

## 🔧 Instalação

1. Clone o repositório:

```bash
git clone https://github.com/ivtrl/Supabase-Backend.git
cd ecommerce-supabase
npm install
```

2. Faça login no Supabase:

```bash
npx supabase login
```

3. Crie um novo projeto ou conecte a um existente:

```bash
npx supabase link --project-ref seu-project-ref
```

4. Execute as migrations:

```bash
npx supabase db push
```

## 🗄️ Estrutura do Banco de Dados

### Tabelas Principais

- **clientes**: Dados dos clientes
- **produtos**: Catálogo de produtos
- **pedidos**: Pedidos realizados
- **itens_pedido**: Itens de cada pedido

### Políticas RLS

- Clientes só acessam seus próprios dados
- Produtos ativos são públicos
- Administradores têm acesso total

## 🤝 Contato

- Email: isaacvitorinola@gmail.com
- LinkedIn: [isaacvla](https://www.linkedin.com/in/isaacvla/)
