import 'package:aulaweb2508/dbhelper.dart';
import 'package:aulaweb2508/models.dart';
import 'package:flutter/material.dart';

class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<StatefulWidget> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  bool _loading = true;
  late List<Contato> contatos;

  @override
  void initState() {
    super.initState();
    _carregarBD();
  }

  void _carregarBD() {
    setState(() {
      _loading = true;
    });
    DBHelper.getInstance()
        .then((value) => value.getAllContatos().then((value) => {
              setState(() => contatos = value),
            }))
        .whenComplete(() => _loading = false);
  }

  ListTile _itemList(BuildContext context, int index) {
    Contato c = contatos[index];

    return ListTile(
        title: Text(c.nome),
        subtitle: Text(c.telefone),
        trailing: ElevatedButton(
            child: Icon(Icons.arrow_right),
            onPressed: () async {
              await Navigator.pushNamed(context, "form_contato", arguments: c);
              _carregarBD();
            }));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Text("Carregando"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contatos cadastrados"),
      ),
      body: ListView.builder(
        itemBuilder: _itemList,
        itemCount: contatos.length,
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.pushNamed(context, 'form_contato');
            setState(() {
              _carregarBD();
            });
          }),
    );
  }
}
