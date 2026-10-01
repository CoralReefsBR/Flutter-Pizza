import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/pedido_pizzaria.dart';
import 'formulario.dart';

class ListaPedidos extends StatefulWidget {
  const ListaPedidos({super.key});

  @override
  State<ListaPedidos> createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  final List<PedidoPizzaria> _pedidos = [
    const PedidoPizzaria(58.90, 1),
    const PedidoPizzaria(74.50, 3),
  ];

  Future<void> _abrirFormulario() async {
    final pedido = await Navigator.push<PedidoPizzaria>(
      context,
      MaterialPageRoute(builder: (_) => const FormularioPedido()),
    );
    if (pedido == null || !mounted) return;

    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _pedidos.add(pedido));
  }

  @override
  Widget build(BuildContext context) {
    final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos da Pizzaria')),
      body: _pedidos.isEmpty
          ? const Center(child: Text('Nenhum pedido cadastrado'))
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: _pedidos.length,
              itemBuilder: (context, index) {
                final pedido = _pedidos[index];
                return Card(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: ListTile(
                    leading: const Icon(Icons.local_pizza, color: Colors.deepOrange),
                    title: Text(formatoMoeda.format(pedido.valor)),
                    subtitle: Text('Mesa ${pedido.numeroMesa}'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        tooltip: 'Adicionar pedido',
        child: const Icon(Icons.add),
      ),
    );
  }
}
