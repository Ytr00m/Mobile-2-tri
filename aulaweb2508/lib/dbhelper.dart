import 'package:aulaweb2508/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static DBHelper? _instance;

  Database? database;

  init() async {
    var dbPath = await getDatabasesPath();
    database = openDatabase(
      join(dbPath, "banco.db"),
      version: 1,
      onCreate: (db, version) async{
        db.execute("""
                CREATE TABLE contatos(
                  id INTEGER PRIMARY KEY,
                  nome TEXT,
                  telefone TEXT
                );
""");
      },
    ) as Database;

  }

  static Future<DBHelper> getInstance() async {
    // ignore: prefer_conditional_assignment
    if(_instance == null) {
      _instance = DBHelper();
      _instance?.init();
    }
    return _instance!;

  }

  static Future<List<Contato>> getAllContatos() async{
    DBHelper helper = await DBHelper.getInstance();
    List<Map<String, Object?>> rows = await helper.database!.query("contatos");
    List<Contato> contatos = List.empty();

    for (var element in rows) {
      contatos.add(Contato(
        id: element["id"] as int, 
        nome: element["nome"] as String, 
        telefone: element["telefone"] as String
        ));
    }

    return contatos;
  }
}