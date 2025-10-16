-- View para relatório de pedidos com detalhes do cliente
CREATE OR REPLACE VIEW vw_pedidos_completos AS
SELECT 
  p.id AS pedido_id,
  p.status,
  p.total,
  p.data_pedido,
  p.data_entrega,
  c.id AS cliente_id,
  c.nome AS cliente_nome,
  c.email AS cliente_email,
  c.telefone AS cliente_telefone,
  COUNT(ip.id) AS total_itens
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
LEFT JOIN itens_pedido ip ON p.id = ip.pedido_id
GROUP BY p.id, c.id;

-- View para detalhes dos itens do pedido
CREATE OR REPLACE VIEW vw_detalhes_pedido AS
SELECT 
  ip.id AS item_id,
  ip.pedido_id,
  ip.quantidade,
  ip.preco_unitario,
  ip.subtotal,
  pr.id AS produto_id,
  pr.nome AS produto_nome,
  pr.descricao AS produto_descricao,
  pr.categoria AS produto_categoria
FROM itens_pedido ip
INNER JOIN produtos pr ON ip.produto_id = pr.id;

-- View para produtos mais vendidos
CREATE OR REPLACE VIEW vw_produtos_mais_vendidos AS
SELECT 
  p.id AS produto_id,
  p.nome AS produto_nome,
  p.categoria,
  SUM(ip.quantidade) AS total_vendido,
  COUNT(DISTINCT ip.pedido_id) AS numero_pedidos,
  SUM(ip.subtotal) AS receita_total
FROM produtos p
INNER JOIN itens_pedido ip ON p.id = ip.produto_id
GROUP BY p.id, p.nome, p.categoria
ORDER BY total_vendido DESC;

-- View para histórico de pedidos do cliente
CREATE OR REPLACE VIEW vw_historico_cliente AS
SELECT 
  c.id AS cliente_id,
  c.nome AS cliente_nome,
  c.email,
  COUNT(p.id) AS total_pedidos,
  SUM(p.total) AS valor_total_compras,
  MAX(p.data_pedido) AS ultima_compra
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nome, c.email;

-- View para produtos com baixo estoque
CREATE OR REPLACE VIEW vw_produtos_baixo_estoque AS
SELECT 
  id,
  nome,
  categoria,
  estoque,
  preco
FROM produtos
WHERE estoque < 10 AND ativo = true
ORDER BY estoque ASC;