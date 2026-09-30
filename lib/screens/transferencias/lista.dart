import 'package:flutter/material.dart';
import '../../models/transferencia.dart';
import 'formulario.dart';
import 'package:intl/intl.dart';
import '../../database/app_database.dart';

class ListaTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencias> {
  static const _tituloAppBar = "Transferências";

  void _atualiza(Transferencia? transferenciaRecebida) {
    if (transferenciaRecebida != null) {
      setState(() {
        widget._transferencias.add(transferenciaRecebida);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tituloAppBar)),
      body: FutureBuilder<List<Transferencia>>(
        future: buscarTransferencias(),
        builder: (context, snapshot) {
          // Verifica se o Future ainda está em execução
          // ConnectionState.waiting indica que a operação assíncrona não terminou
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mostra um indicador de progresso centralizado enquanto os dados carregam
            return Center(child: CircularProgressIndicator());
          }

          // Verifica se ocorreu algum erro durante a execução do Future
          if (snapshot.hasError) {
            // Mostra uma mensagem de erro centralizada
            return Center(child: Text('Erro ao carregar transferências'));
          }

          // Verifica se não há dados ou se a lista retornada está vazia
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Mostra uma mensagem indicando que não há transferências
            return Center(child: Text('Nenhuma transferência encontrada'));
          }

          final transferencias = snapshot.data!;

          return ListView.builder(
            itemCount: transferencias.length,
            itemBuilder: (context, indice) {
              final transferencia = transferencias[indice];
               return ItemTransferencia(transferencia);
            }

          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Botão + pressionado");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return FormularioTransferencia();
              },
            ),
          ).then((transferenciaRecebida) => _atualiza(transferenciaRecebida));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    NumberFormat formato = NumberFormat.simpleCurrency();
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(formato.format(_transferencia.valor).toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}
