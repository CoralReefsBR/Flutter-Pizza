import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/pedido_pizzaria.dart';
import '../services/pedido_api_service.dart';

class PedidoRepository {
  PedidoRepository({AppDatabase? database, PedidoApiService? api})
      : _database = database ?? AppDatabase.instance,
        _api = api ?? PedidoApiService();
  final AppDatabase _database;
  final PedidoApiService _api;

  Future<List<PedidoPizzaria>> listar() async {
    final db = await _database.database;
    try {
      final remotos = await _api.listar();
      await db.transaction((txn) async {
        await txn.delete('pedidos', where: 'sincronizado = 1');
        for (final pedido in remotos) {
          await txn.insert('pedidos', pedido.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    } catch (_) {
      // Offline: mantém e mostra o cache local.
    }
    final rows = await db.query('pedidos', orderBy: 'id DESC');
    return rows.map(PedidoPizzaria.fromMap).toList();
  }

  Future<bool> criar(PedidoPizzaria pedido) async {
    final db = await _database.database;
    try {
      await _api.criar(pedido);
      await db.insert('pedidos', pedido.copyWith(sincronizado: true).toMap());
      return true;
    } catch (_) {
      await db.insert('pedidos', pedido.copyWith(sincronizado: false).toMap());
      return false;
    }
  }

  Future<int> sincronizarPendentes() async {
    final db = await _database.database;
    final rows = await db.query('pedidos', where: 'sincronizado = 0', orderBy: 'id ASC');
    var sincronizados = 0;
    for (final row in rows) {
      final pedido = PedidoPizzaria.fromMap(row);
      try {
        await _api.criar(pedido);
        await db.update('pedidos', {'sincronizado': 1}, where: 'id = ?', whereArgs: [pedido.id]);
        sincronizados++;
      } catch (_) {
        break;
      }
    }
    return sincronizados;
  }
}
