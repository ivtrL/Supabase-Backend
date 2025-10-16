# Sistema de E-commerce - Backend Supabase

Backend completo para sistema de e-commerce desenvolvido com Supabase, incluindo autenticação, RLS, funções automatizadas e Edge Functions.

## 🚀 Funcionalidades Implementadas

- ✅ Tabelas para clientes, produtos e pedidos
- ✅ Row-Level Security (RLS) completo
- ✅ Funções no banco de dados para automação
- ✅ Views para consultas otimizadas
- ✅ Edge Functions para e-mail e exportação CSV

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

5. Faça deploy das Edge Functions:

```bash
npx supabase functions deploy enviar-email-confirmacao
npx supabase functions deploy exportar-pedido-csv
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

### Funções Principais

- `criar_pedido_completo()`: Cria pedido com validação de estoque
- `calcular_total_pedido()`: Calcula total automaticamente
- `atualizar_status_pedido()`: Atualiza status do pedido

### Views

- `vw_pedidos_completos`: Pedidos com dados do cliente
- `vw_detalhes_pedido`: Detalhes dos itens
- `vw_produtos_mais_vendidos`: Ranking de produtos
- `vw_historico_cliente`: Histórico de compras

## 🧪 Exemplos de Uso

### Criar um Pedido

```javascript
const { data, error } = await supabase.rpc("criar_pedido_completo", {
  p_cliente_id: "uuid-do-cliente",
  p_itens: [
    { produto_id: "uuid-produto-1", quantidade: 2 },
    { produto_id: "uuid-produto-2", quantidade: 1 },
  ],
});
```

### Exportar Pedido para CSV

```javascript
const { data } = await supabase.functions.invoke("exportar-pedido-csv", {
  body: {
    pedido_id: "uuid-do-pedido",
    cliente_id: "uuid-do-cliente",
  },
});
```

## 🔐 Variáveis de Ambiente

Crie um arquivo `.env.local` com:

```env
SUPABASE_URL=sua-url
SUPABASE_ANON_KEY=sua-key
RESEND_API_KEY=sua-key-resend
```

## 🤝 Contato

- Email: isaacvitorinola@gmail.com
- LinkedIn: [isaacvla](https://www.linkedin.com/in/isaacvla/)
