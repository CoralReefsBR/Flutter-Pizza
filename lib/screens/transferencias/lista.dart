import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/pedido_pizzaria.dart';
import '../../repository/pedido_repository.dart';
import 'formulario.dart';

class ListaPedidos extends StatefulWidget {
  const ListaPedidos({super.key});
  @override
  State<ListaPedidos> createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  final _repository = PedidoRepository();
  List<PedidoPizzaria> _pedidos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final pedidos = await _repository.listar();
    if (!mounted) return;
    setState(() { _pedidos = pedidos; _carregando = false; });
  }

  Future<void> _abrirFormulario() async {
    final pedido = await Navigator.push<PedidoPizzaria>(
      context, MaterialPageRoute(builder: (_) => const FormularioPedido()));
    if (pedido == null) return;
    final enviado = await _repository.criar(pedido);
    await _carregar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
      enviado ? 'Pedido enviado e salvo.' : 'Sem conexão: pedido salvo como pendente.')));
  }

  Future<void> _sincronizar() async {
    final quantidade = await _repository.sincronizarPendentes();
    await _carregar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
      quantidade == 0 ? 'Nenhum pedido sincronizado. Verifique a conexão.' : '$quantidade pedido(s) sincronizado(s).')));
  }

  @override
  Widget build(BuildContext context) {
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final pendentes = _pedidos.where((p) => !p.sincronizado).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos da Pizzaria'), actions: [
        IconButton(tooltip: 'Sincronizar pendentes', onPressed: _sincronizar,
          icon: Badge(isLabelVisible: pendentes > 0, label: Text('$pendentes'), child: const Icon(Icons.sync))),
      ]),
      body: _carregando ? const Center(child: CircularProgressIndicator())
        : _pedidos.isEmpty ? const Center(child: Text('Nenhum pedido cadastrado'))
        : RefreshIndicator(onRefresh: _carregar, child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 88), itemCount: _pedidos.length,
            itemBuilder: (context, index) {
              final pedido = _pedidos[index];
              return Card(margin: const EdgeInsets.fromLTRB(16, 8, 16, 4), child: ListTile(
                leading: const Icon(Icons.local_pizza, color: Colors.deepOrange),
                title: Text(moeda.format(pedido.valor)), subtitle: Text('Mesa ${pedido.numeroMesa}'),
                trailing: Icon(pedido.sincronizado ? Icons.cloud_done : Icons.cloud_off,
                  color: pedido.sincronizado ? Colors.green : Colors.orange),
              ));
            })),
      floatingActionButton: FloatingActionButton(onPressed: _abrirFormulario,
        tooltip: 'Adicionar pedido', child: const Icon(Icons.add)),
    );
  }
}
