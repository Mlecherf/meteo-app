import 'package:sqflite/sqflite.dart';

class Data {
  static final Data data = Data._init();

  static Database? _database;

  Data._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('./data.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE ');
  }

  Future close() async {
    final db = await data.database;

    db.close();
  }
}
