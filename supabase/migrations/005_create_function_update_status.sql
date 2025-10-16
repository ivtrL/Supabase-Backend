
CREATE OR REPLACE FUNCTION atualizar_status_pedido(
  pedido_uuid UUID,
  novo_status VARCHAR(50)
)
RETURNS VOID AS $$
BEGIN
  UPDATE pedidos
  SET status = novo_status,
      updated_at = NOW(),
      data_entrega = CASE 
        WHEN novo_status = 'entregue' THEN NOW()
        ELSE data_entrega
      END
  WHERE id = pedido_uuid;
END;
$$ LANGUAGE plpgsql;