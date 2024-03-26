import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


Future<Database> startDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), "task_database.db"),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE lanak(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, projected FLOAT, hours FLOAT, start TEXT)",
      );
    },
    version: 1,
  );

  return database;
}

class Lana {
  final int id;            // Unique ID of the task
  final String name;       // Name of the task
  final double projected;  // Projected weekly hours to work on the task
  final double hours;      // Hours worked on the task
  final String start;      // Timestamp when Lana was created

  const Lana({
    required this.id,
    required this.name,
    required this.projected,
    required this.hours,
    required this.start,
  });
}

Future<Map<String, dynamic>> getLana (lanaId) async {
  final db = await startDatabase();

  final List<Map<String, dynamic>> lanak = await db.query(
    "lanak",
    where: "id=?",
    whereArgs: [lanaId],
    limit: 1,
  );

  return lanak[0];
}

void saveLana (context, lanaId, lanaName, lanaProjected) async {
  Map<String, dynamic> lanaDict = {};
  if (lanaId != -1) {  // update
      Map<String, dynamic> rawLanaDict = await getLana(lanaId);
      lanaDict = Map.of(rawLanaDict);
  } else {  // insert
      lanaDict["start"] = DateTime.now().toString();
      lanaDict["hours"] = 0;
  }
  lanaDict["name"] = lanaName;
  lanaDict["projected"] = double.parse(lanaProjected)/60;

  final db = await startDatabase();

  await db.insert(
      "lanak",
      lanaDict,
      conflictAlgorithm: ConflictAlgorithm.replace,
  );

  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
          "Lana '$lanaName' saved")
      )
  );
}

void saveSession (context, lanaId, timestamp, seconds) async {
  final db = await startDatabase();
  Map<String, dynamic> lana = await getLana(lanaId);
  final lanaDict = Map.of(lana);  // otherwise 'lana' is immutable, from db
  lanaDict["hours"] = lana["hours"] + seconds/3600;

  await db.insert(
    "lanak",
    lanaDict,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

void deleteLanaDatabase () async {
  final dbPath = join(await getDatabasesPath(), "task_database.db");
  deleteDatabase(dbPath);
}

void deleteLana (lanaDict) async {
  final db = await startDatabase();
  int lanaId = lanaDict["id"];

  await db.delete("lanak", where: "id = ?", whereArgs: [lanaId]);
}

Future<List<Map<String, dynamic>>> getTasks() async {
  final db = await startDatabase();
  final List<Map<String, dynamic>> maps = await db.query("lanak");

  return maps;
}
