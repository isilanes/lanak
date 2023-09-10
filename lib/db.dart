import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


Future<Database> startDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), "task_database.db"),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, hours FLOAT)",
      );
    },
    version: 1,
  );

  return database;
}

class Task {
  final int id;
  final String name;
  final double hours;

  const Task({
    required this.id,
    required this.name,
    required this.hours,
  });
}

void saveTask (context, taskName, taskHours) async {
  Map<String, Object> taskDict = {
    "name": taskName,
    "hours": taskHours,
  };
  final db = await startDatabase();

  await db.insert(
    "tasks",
    taskDict,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
            "Task '$taskName' saved")
        )
  );
}

void deleteLanaDatabase () async {
  final dbPath = join(await getDatabasesPath(), "task_database.db");
  deleteDatabase(dbPath);
}

Future<List<Map<String, dynamic>>> getTasks() async {
  final db = await startDatabase();
  final List<Map<String, dynamic>> maps = await db.query("tasks");

  print(maps);

  return maps;

  // return [
  //   for (final map in maps)
  //     map["name"]
  // ];
}
