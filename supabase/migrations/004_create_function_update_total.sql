CREATE OR REPLACE FUNCTION atualizar_total_pedido()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE pedidos
  SET total = calcular_total_pedido(NEW.pedido_id),
      updated_at = NOW()
  WHERE id = NEW.pedido_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;