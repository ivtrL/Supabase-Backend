// supabase/functions/enviar-email-confirmacao/index.ts

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY");

serve(async (req) => {
  try {
    const { pedido_id } = await req.json();

    // Criar cliente Supabase
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    );

    // Buscar dados do pedido
    const { data: pedido, error: pedidoError } = await supabaseClient
      .from("vw_pedidos_completos")
      .select("*")
      .eq("pedido_id", pedido_id)
      .single();

    if (pedidoError) throw pedidoError;

    // Buscar itens do pedido
    const { data: itens, error: itensError } = await supabaseClient
      .from("vw_detalhes_pedido")
      .select("*")
      .eq("pedido_id", pedido_id);

    if (itensError) throw itensError;

    // Montar HTML do e-mail
    const itensHtml = itens
      .map(
        (item) => `
      <tr>
        <td>${item.produto_nome}</td>
        <td>${item.quantidade}</td>
        <td>R$ ${item.preco_unitario.toFixed(2)}</td>
        <td>R$ ${item.subtotal.toFixed(2)}</td>
      </tr>
    `,
      )
      .join("");

    const emailHtml = `
      <html>
        <body>
          <h1>Confirmação de Pedido #${pedido.pedido_id.substring(0, 8)}</h1>
          <p>Olá ${pedido.cliente_nome},</p>
          <p>Seu pedido foi recebido com sucesso!</p>
          
          <h2>Detalhes do Pedido:</h2>
          <table border="1" cellpadding="10">
            <thead>
              <tr>
                <th>Produto</th>
                <th>Quantidade</th>
                <th>Preço Unitário</th>
                <th>Subtotal</th>
              </tr>
            </thead>
            <tbody>
              ${itensHtml}
            </tbody>
          </table>
          
          <h3>Total: R$ ${pedido.total.toFixed(2)}</h3>
          <p>Data do pedido: ${
      new Date(pedido.data_pedido).toLocaleString(
        "pt-BR",
      )
    }</p>
          <p>Status: ${pedido.status}</p>
          
          <p>Obrigado por sua compra!</p>
        </body>
      </html>
    `;

    // Enviar e-mail usando Resend
    const res = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${RESEND_API_KEY}`,
      },
      body: JSON.stringify({
        from: "noreply@seuecommerce.com",
        to: pedido.cliente_email,
        subject: `Confirmação de Pedido #${pedido.pedido_id.substring(0, 8)}`,
        html: emailHtml,
      }),
    });

    const data = await res.json();

    return new Response(JSON.stringify({ success: true, data }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }
});
