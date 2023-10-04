import 'package:lanak/db.dart';


Future<double> totalLanaRunHours(int lanaId) async {
  final db = await startDatabase();
  final List<Map<String, dynamic>> sessions = await db.query(
    "sessions",
    where: "task_id=?",
    whereArgs: [lanaId],
  );

  double totalSeconds = 0.0;
  for (final session in sessions) {
    totalSeconds = totalSeconds + session["seconds"];
  }

  return totalSeconds / 3600;
}

Future<int> totalLanaAgeHours(int lanaId) async {
  final db = await startDatabase();

  final List<Map<String, dynamic>> first = await db.query(
    "sessions",
    where: "task_id=?",
    whereArgs: [lanaId],
    orderBy: "timestamp ASC",
    limit: 1,
  );

  if (first.isEmpty) {
    return 168;  // if no value, assume 1 week
  }

  String firstTimeStamp = first[0]["timestamp"];
  DateTime firstDateTime = DateTime.parse(firstTimeStamp);
  Duration age = DateTime.now().difference(firstDateTime);

  return age.inHours;
}

Future<double> realWeeklyHours(int lanaId) async {
  double totalHours = await totalLanaRunHours(lanaId);
  double ageHours = (await totalLanaAgeHours(lanaId)).toDouble();

  return totalHours*168/ageHours; // 1 week == 168 h
}

Future<double> lagBehind(int lanaId) async {
  // How many hours MORE we would have to run RIGHT NOW, so that the
  // expected weekly hours were met. For example: a Lana is configured
  // to run "2h per week". It started 21 days ago (so, 3 weeks). Then, it
  // should have run for 6h since then. If it has been actually run for
  // 3.5h, then it "lags behind" by 2.5h. If the lag is negative, then,
  // of course, it means that we have run the Lana even more than expected.
  final db = await startDatabase();

  final List<Map<String, dynamic>> lana = await db.query(
    "tasks",
    where: "id=?",
    whereArgs: [lanaId],
    limit: 1,
  );
  double expectedWeeklyHours = lana[0]["hours"];
  double ageHours = (await totalLanaAgeHours(lanaId)).toDouble();
  double expectedRunHours = expectedWeeklyHours*ageHours/168;
  double realRunHours = await totalLanaRunHours(lanaId);

  return expectedRunHours - realRunHours;
}

Future<List<Map<String, dynamic>>> getLanakWithLag() async {
  final db = await startDatabase();
  final List<Map<String, dynamic>> lanaDicts = await db.query("tasks");
  final List<Map<String, dynamic>> lanaDictsWithLag = [];

  for (final lanaDict in lanaDicts) {
    Map<String, dynamic> newLanaDict = Map<String, dynamic>.from(lanaDict);
    newLanaDict["lag"] = await lagBehind(lanaDict["id"]);
    lanaDictsWithLag.add(newLanaDict);
  }

  lanaDictsWithLag.sort((a, b) => b["lag"].compareTo(a["lag"]));

  return lanaDictsWithLag;
}
