import 'package:aulaweb2508/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static DBHelper? _instance;

  late Database _database;

  _init() async {
    var dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, "banco.db"),
      version: 1,
      onCreate: (db, version) async {
        db.execute("""
                CREATE TABLE contatos(
                  id INTEGER PRIMARY KEY,
                  nome TEXT,
                  telefone TEXT
                );
""");
      },
    );
  }

  static Future<DBHelper> getInstance() async {
    // ignore: prefer_conditional_assignment
    if (_instance == null) {
      _instance = DBHelper();
      await _instance?._init();
    }
    return _instance!;
  }

  Future<List<Contato>> getAllContatos() async {
    List<Map<String, Object?>> rows = await _database.query("contatos");
    List<Contato> contatos = List.empty(growable: true);

    for (var element in rows) {
      contatos.add(Contato(
          id: element["id"] as int,
          nome: element["nome"] as String,
          telefone: element["telefone"] as String));
    }

    return contatos;
  }

  Future<void> salvarContato(Contato contato) async {
    if (contato.id == 0) {
      contato.id = await _database.insert(
          "contatos", {"nome": contato.nome, "telefone": contato.telefone});
    } else {
      await _database.update(
          "contatos", {"nome": contato.nome, "telefone": contato.telefone},
          where: "id = ${contato.id}");
    }
  }

  Future<void> deletarContato(Contato contato) async {
    await _database.delete("contatos", where: "id = ${contato.id}");
  }
}
