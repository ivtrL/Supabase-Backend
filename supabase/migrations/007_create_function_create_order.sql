
CREATE OR REPLACE FUNCTION criar_pedido_completo(
  p_cliente_id UUID,
  p_itens JSONB,
  p_observacoes TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
  novo_pedido_id UUID;
  item JSONB;
  produto_preco DECIMAL(10, 2);
  estoque_disponivel BOOLEAN;
BEGIN
  -- Criar o pedido
  INSERT INTO pedidos (cliente_id, status, total, observacoes)
  VALUES (p_cliente_id, 'pendente', 0, p_observacoes)
  RETURNING id INTO novo_pedido_id;
  
  -- Adicionar itens ao pedido
  FOR item IN SELECT * FROM jsonb_array_elements(p_itens)
  LOOP
    -- Obter preço atual do produto
    SELECT preco INTO produto_preco
    FROM produtos
    WHERE id = (item->>'produto_id')::UUID;
    
    -- Verificar e atualizar estoque
    estoque_disponivel := atualizar_estoque_produto(
      (item->>'produto_id')::UUID,
      (item->>'quantidade')::INTEGER
    );
    
    IF NOT estoque_disponivel THEN
      RAISE EXCEPTION 'Estoque insuficiente para o produto %', item->>'produto_id';
    END IF;
    
    -- Inserir item do pedido
    INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario, subtotal)
    VALUES (
      novo_pedido_id,
      (item->>'produto_id')::UUID,
      (item->>'quantidade')::INTEGER,
      produto_preco,
      produto_preco * (item->>'quantidade')::INTEGER
    );
  END LOOP;
  
  RETURN novo_pedido_id;
END;
$$ LANGUAGE plpgsql;
