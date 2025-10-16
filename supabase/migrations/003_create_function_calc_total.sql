CREATE OR REPLACE FUNCTION calcular_total_pedido(pedido_uuid UUID)
RETURNS DECIMAL AS $$
DECLARE
  total_calculado DECIMAL(10, 2);
BEGIN
  SELECT COALESCE(SUM(subtotal), 0)
  INTO total_calculado
  FROM itens_pedido
  WHERE pedido_id = pedido_uuid;
  
  RETURN total_calculado;
END;
$$ LANGUAGE plpgsql;