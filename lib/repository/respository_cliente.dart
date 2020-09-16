import 'package:app_sqlite/classes/cliente.dart';
import 'package:app_sqlite/utils/ddl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryCliente {
  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      onCreate: (db, version) {
        return db.execute(CREATE_TABLE_CLIENTE);
      },
      version: 1,
    );
  }

  Future<String> countRegistry() async {
    try {
      final Database db = await _getDatabase();
      final data = await db.rawQuery('SELECT count(*) as total FROM cliente');
      return data[0]['total'].toString();
    } catch (e) {
      print(e);
      return '-1';
    }
  }

  Future<List<Cliente>> getClientes() async {
    try {
      final Database db = await _getDatabase();
      final List<Map<String, dynamic>> maps =
          await db.query('cliente', orderBy: 'id DESC');
      return List.generate(maps.length, (i) {
        return Cliente.fromMap(maps[i]);
      });
    } catch (e) {
      print(e);
      return List<Cliente>();
    }
  }

  Future<List<Cliente>> getClientesNome(String nome) async {
    try {
      final Database db = await _getDatabase();
      final List<Map<String, dynamic>> maps = await db.query('cliente',
          where: 'nome LIKE ?',
          whereArgs: ['%' + nome + '%'],
          orderBy: 'id Desc');

      return List.generate(maps.length, (index) {
        return Cliente.fromMap(maps[index]);
      });
    } catch (e) {
      print(e);
      return List<Cliente>();
    }
  }

  Future insertCliente(Cliente cliente) async {
    try {
      final Database db = await _getDatabase();
      await db.insert('cliente', cliente.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future updateCliente(Cliente cliente) async {
    try {
      final Database db = await _getDatabase();
      await db.update('cliente', cliente.toMap(),
          where: 'id = ?', whereArgs: [cliente.id]);
    } catch (e) {
      print(e);
    }
  }

  Future deleteCliente(Cliente cliente) async {
    try {
      final Database db = await _getDatabase();
      await db.delete('cliente', where: 'id = ?', whereArgs: [cliente.id]);
    } catch (e) {
      print(e);
    }
  }

  Future clearTable() async {
    try {
      final Database db = await _getDatabase();
      await db.rawQuery('DELETE FROM cliente');
    } catch (e) {
      print(e);
    }
  }
}
