import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = path.join(await getDatabasesPath(), 'pizzaria.db');
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE pedidos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          remote_id INTEGER,
          valor REAL NOT NULL,
          numero_mesa INTEGER NOT NULL,
          sincronizado INTEGER NOT NULL DEFAULT 0
        )
      '''),
    );
    return _database!;
  }
}
