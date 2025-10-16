ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedidos ENABLE ROW LEVEL SECURITY;
ALTER TABLE itens_pedido ENABLE ROW LEVEL SECURITY;

-- Políticas para CLIENTES
CREATE POLICY "Clientes podem ver apenas seus dados"
  ON clientes FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Clientes podem atualizar seus dados"
  ON clientes FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Permitir registro de clientes"
  ON clientes FOR INSERT
  WITH CHECK (true);

-- Políticas para PRODUTOS
CREATE POLICY "Produtos ativos são públicos"
  ON produtos FOR SELECT
  USING (ativo = true);

CREATE POLICY "Admin pode gerenciar produtos"
  ON produtos FOR ALL
  USING (auth.jwt() ->> 'role' = 'admin');

-- Políticas para PEDIDOS
CREATE POLICY "Clientes veem apenas seus pedidos"
  ON pedidos FOR SELECT
  USING (auth.uid() = cliente_id);

CREATE POLICY "Clientes podem criar pedidos"
  ON pedidos FOR INSERT
  WITH CHECK (auth.uid() = cliente_id);

CREATE POLICY "Cliente ou admin podem atualizar pedidos"
  ON pedidos FOR UPDATE
  USING (auth.uid() = cliente_id OR auth.jwt() ->> 'role' = 'admin');

-- Políticas para ITENS_PEDIDO
CREATE POLICY "Ver itens dos próprios pedidos"
  ON itens_pedido FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM pedidos 
      WHERE pedidos.id = itens_pedido.pedido_id 
      AND pedidos.cliente_id = auth.uid()
    )
  );

CREATE POLICY "Inserir itens do pedido"
  ON itens_pedido FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM pedidos 
      WHERE pedidos.id = itens_pedido.pedido_id 
      AND pedidos.cliente_id = auth.uid()
    )
  );