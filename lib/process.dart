import 'package:lanak/db.dart';


Future<double> totalLanaRunHours(int lanaId) async {
  final Map<String, dynamic> lana = await getLana(lanaId);

  return lana["hours"];
}

Future<double> totalLanaAgeHours(int lanaId) async {
  final Map<String, dynamic> lana = await getLana(lanaId);
  DateTime firstDateTime = DateTime.parse(lana["start"]);
  Duration age = DateTime.now().difference(firstDateTime);

  return age.inSeconds/3600;
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
  final Map<String, dynamic> lana = await getLana(lanaId);

  double expectedWeeklyHours = lana["projected"];
  double ageHours = (await totalLanaAgeHours(lanaId)).toDouble();
  double expectedRunHours = expectedWeeklyHours*ageHours/168;

  return expectedRunHours - lana["hours"];
}

Future<List<Map<String, dynamic>>> getLanakWithLag() async {
  final db = await startDatabase();
  final List<Map<String, dynamic>> lanaDicts = await db.query("lanak");
  final List<Map<String, dynamic>> lanaDictsWithLag = [];

  for (final lanaDict in lanaDicts) {
      Map<String, dynamic> newLanaDict = Map<String, dynamic>.from(lanaDict);
      newLanaDict["lag"] = await lagBehind(lanaDict["id"]);
      lanaDictsWithLag.add(newLanaDict);
  }

  lanaDictsWithLag.sort((a, b) => b["lag"].compareTo(a["lag"]));

  return lanaDictsWithLag;
}
