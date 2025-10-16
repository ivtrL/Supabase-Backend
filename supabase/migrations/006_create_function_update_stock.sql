
CREATE OR REPLACE FUNCTION atualizar_estoque_produto(
  produto_uuid UUID,
  quantidade_vendida INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
  estoque_atual INTEGER;
BEGIN
  SELECT estoque INTO estoque_atual
  FROM produtos
  WHERE id = produto_uuid;
  
  IF estoque_atual >= quantidade_vendida THEN
    UPDATE produtos
    SET estoque = estoque - quantidade_vendida,
        updated_at = NOW()
    WHERE id = produto_uuid;
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;
$$ LANGUAGE plpgsql;