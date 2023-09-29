import 'package:aulaweb2508/dbhelper.dart';
import 'package:aulaweb2508/models.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FormContato extends StatefulWidget {
  @override
  State<FormContato> createState() => _FormContatoState();
}

class _FormContatoState extends State<FormContato> {
  bool _loading = true;
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _telefone = TextEditingController();
  int _id = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _loading = false;

      if (ModalRoute.of(context)!.settings.arguments != null) {
        Contato c = ModalRoute.of(context)!.settings.arguments as Contato;
        _nome.text = c.nome;
        _telefone.text = c.telefone;
        _id = c.id;
      }
    });
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário de contato"),
      ),
      body: Column(
        children: [
          const Text("Nome:"),
          TextField(
            controller: _nome,
          ),
          const Text("Telefone:"),
          TextField(
            controller: _telefone,
          ),
          ElevatedButton(
            child: const Text("Salvar"),
            onPressed: () {
              Contato c =
                  Contato(nome: _nome.text, telefone: _telefone.text, id: _id);
              DBHelper.getInstance().then((value) => value.salvarContato(c));
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: const Text("Deletar"),
            onPressed: () {
              Contato c =
                  Contato(nome: _nome.text, telefone: _telefone.text, id: _id);
              DBHelper.getInstance().then((value) => value.deletarContato(c));
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
