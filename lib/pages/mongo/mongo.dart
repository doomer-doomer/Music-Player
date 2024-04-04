import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

class Mongo {
  static var _db;

  static Future<void> connect() async {
    _db = Db('mongodb+srv://tejas:tejas@cluster0.0hu0hq9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0');
    await _db.open();
    print('Connected to database');
  }

  static Db get db => _db;
}
