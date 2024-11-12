import 'package:dtt_real_estate/Provider/ApiProvider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class WishlistDatabase {
  static final WishlistDatabase instance = WishlistDatabase._init();
  static Database? _database;

  WishlistDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wishlist.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE wishlist (
            id INTEGER PRIMARY KEY,
            imageUrl TEXT,
            price INTEGER,
            bedrooms INTEGER,
            bathrooms INTEGER,
            size INTEGER,
            description TEXT,
            city TEXT,
            zip TEXT,
            date TEXT,
            lattitude INTEGER,
            longitude INTEGER
          )
        ''');
      },
    );
  }

  // Insert a house item into the wishlist
  Future<void> insertHouse(House house) async {
    final db = await instance.database;
    await db.insert(
      'wishlist',
      house.toMap(house),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all houses from the wishlist
  Future<List<House>> getWishlist() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('wishlist');

    return maps.map((map) => House.fromMap(map)).toList();
  }

  // Delete a house item from the wishlist
  Future<void> deleteHouse(int id) async {
    final db = await instance.database;
    await db.delete(
      'wishlist',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
