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
        "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, hours FLOAT)",
      );
      db.execute(
        "CREATE TABLE sessions(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, task_id INTEGER, seconds FLOAT, timestamp TEXT)",
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

class Session {
  final int id;
  final int taskId;  // FK to Task
  final double seconds;
  final String timestamp;

  const Session({
    required this.id,
    required this.taskId,
    required this.seconds,
    required this.timestamp,
  });
}

void saveTask (context, lanaId, lanaName, lanaHours) async {
  Map<String, Object> lanaDict = {
    "name": lanaName,
    "hours": lanaHours,
  };
  if (lanaId != -1) {
    lanaDict["id"] = lanaId;
  }
  final db = await startDatabase();

  await db.insert(
    "tasks",
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
  Map<String, Object> sessionDict = {
    "task_id": lanaId,
    "seconds": seconds,
    "timestamp": timestamp,
  };
  final db = await startDatabase();

  await db.insert(
    "sessions",
    sessionDict,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

void deleteLanaDatabase () async {
  final dbPath = join(await getDatabasesPath(), "task_database.db");
  deleteDatabase(dbPath);
}

Future<List<Map<String, dynamic>>> getTasks() async {
  final db = await startDatabase();
  final List<Map<String, dynamic>> maps = await db.query("tasks");

  return maps;
}

Future<List<Map<String, dynamic>>> getSessionsOf(int lanaId, [int limit = 10]) async {
  final db = await startDatabase();
  final List<Map<String, dynamic>> sessions = await db.query(
      "sessions",
      where: "task_id=?",
      whereArgs: [lanaId],
      limit: limit,
      orderBy: "timestamp DESC",
  );

  return sessions;
}
