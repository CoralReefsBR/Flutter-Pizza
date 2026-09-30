import 'package:flutter/material.dart';
import './contatos/lista_contatos.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),

      body: Column(
        // alinhamento vertical
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,

        //alinhamento horizontal
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("images/bytebank_logo.png"),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),

              color: Colors.green.shade700,

              height: 120,
              width: 100,

              child: Material(
                color: const Color.fromARGB(0, 0, 0, 0),

                child: InkWell(
                  
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListaContatos(),
                      ),
                    );
                  },

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.people, color: Colors.white, size: 32),

                      SizedBox(height: 8),

                      Text(
                        "Contacts",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
