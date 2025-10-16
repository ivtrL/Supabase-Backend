// supabase/functions/exportar-pedido-csv/index.ts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

serve(async (req) => {
  try {
    const { pedido_id, cliente_id } = await req.json();

    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    );

    // Buscar dados do pedido
    const { data: pedido, error: pedidoError } = await supabaseClient
      .from("vw_pedidos_completos")
      .select("*")
      .eq("pedido_id", pedido_id)
      .eq("cliente_id", cliente_id)
      .single();

    if (pedidoError) throw pedidoError;

    // Buscar itens do pedido
    const { data: itens, error: itensError } = await supabaseClient
      .from("vw_detalhes_pedido")
      .select("*")
      .eq("pedido_id", pedido_id);

    if (itensError) throw itensError;

    // Gerar CSV
    let csv = "Produto,Quantidade,Preço Unitário,Subtotal\n";

    itens.forEach((item) => {
      csv +=
        `"${item.produto_nome}",${item.quantidade},${item.preco_unitario},${item.subtotal}\n`;
    });

    csv += `\nTotal do Pedido:,,,${pedido.total}\n`;
    csv += `Status:,${pedido.status},,\n`;
    csv += `Data:,${
      new Date(pedido.data_pedido).toLocaleDateString(
        "pt-BR",
      )
    },,\n`;

    return new Response(csv, {
      headers: {
        "Content-Type": "text/csv",
        "Content-Disposition": `attachment; filename="pedido_${
          pedido_id.substring(
            0,
            8,
          )
        }.csv"`,
      },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }
});
