import 'package:flutter/material.dart';

import '../../components/editor.dart';
import '../../models/pedido_pizzaria.dart';

class FormularioPedido extends StatefulWidget {
  const FormularioPedido({super.key});

  @override
  State<FormularioPedido> createState() => _FormularioPedidoState();
}

class _FormularioPedidoState extends State<FormularioPedido> {
  final _controladorMesa = TextEditingController();
  final _controladorValor = TextEditingController();

  @override
  void dispose() {
    _controladorMesa.dispose();
    _controladorValor.dispose();
    super.dispose();
  }

  void _confirmar() {
    final mesa = int.tryParse(_controladorMesa.text.trim());
    final valorTexto = _controladorValor.text.trim().replaceAll(',', '.');
    final valor = double.tryParse(valorTexto);

    if (mesa == null || mesa <= 0 || valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe uma mesa e um valor válidos.')),
      );
      return;
    }

    Navigator.pop(context, PedidoPizzaria(valor, mesa));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo pedido')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(Icons.local_pizza, size: 64, color: Colors.deepOrange),
          const SizedBox(height: 16),
          Editor(
            controlador: _controladorMesa,
            rotulo: 'Número da mesa',
            dica: 'Ex.: 4',
            icone: Icons.table_restaurant,
            tipoTeclado: TextInputType.number,
          ),
          Editor(
            controlador: _controladorValor,
            rotulo: 'Valor do pedido',
            dica: 'Ex.: 58,90',
            icone: Icons.attach_money,
            tipoTeclado: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _confirmar,
            icon: const Icon(Icons.check),
            label: const Text('Confirmar pedido'),
          ),
        ],
      ),
    );
  }
}
