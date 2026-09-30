import 'package:flutter/material.dart';
import 'formulario_contato.dart';

class ListaContatos extends StatelessWidget {
  const ListaContatos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Contatos')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Maria'),
            subtitle: Text('Conta: 1234'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('João'),
            subtitle: Text('Conta: 5678'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Carla'),
            subtitle: Text('Conta: 9101'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormularioContato()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
