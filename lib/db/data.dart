import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:meteo_app/models/openweathermap.dart';

class Data {
  static final Data instance = Data._init();

  static Database? _database;

  Data._init();

  // ignore: non_constant_identifier_names
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB('cities.db');
    return _database!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE $tableCities (
      ${CityFields.id} $idType,
      ${CityFields.name} $textType
    )
    ''');
  }

  Future create(City city) async {
    final db = await instance.database;
    final id = await db.insert(tableCities, city.toJson());
    return city.copy(id: id);
  }

  Future<City> readCity(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCities,
      columns: CityFields.values,
      where: '${CityFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return City.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<City>> readAllCities() async {
    final db = await instance.database;

    final result = await db.query(tableCities);

    return result.map((json) => City.fromJson(json)).toList();
  }

  Future<int> update(City city) async {
    final db = await instance.database;

    return db.update(
      tableCities,
      city.toJson(),
      where: '${CityFields.id} = ?',
      whereArgs: [city.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableCities,
      where: '${CityFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
