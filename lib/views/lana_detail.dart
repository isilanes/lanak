import 'package:flutter/material.dart';

import 'package:lanak/db.dart';
import 'package:lanak/process.dart';
import 'package:lanak/views/lana_edit.dart';
import 'package:lanak/views/lana_run.dart';


String hoursToHuman(num hours) {
  if (hours > 168) {
    return "${(hours/168.0).toStringAsFixed(1)} weeks";
  } else if (hours > 24) {
      return "${(hours/24.0).toStringAsFixed(1)} days";
  }
  return "${hours.toStringAsFixed(1)} hours";
}

class LanaDetailView extends StatefulWidget {
  final Map<String, dynamic> lana;

  const LanaDetailView(this.lana, {super.key});

  final String title = "Lana detail";

  @override
  State<LanaDetailView> createState() => _LanaDetailViewState();
}


class _LanaDetailViewState extends State<LanaDetailView> {
  final styleLanaName = const TextStyle(fontSize: 32);
  final styleLanaTime = const TextStyle(
    fontSize: 20,
    color: Colors.brown,
  );
  final styleSessionDate = const TextStyle(
    fontSize: 16,
    color: Colors.black,
  );
  final styleSessionElapsed = const TextStyle(
    fontSize: 16,
    color: Colors.deepOrange,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _lanaDetail(),
    );
  }

  Future<List<Widget>> _events() async {
    final sessions = await getSessionsOf(widget.lana["id"]);

    return sessions.map(
            (e) {
              String ts = e["timestamp"].substring(0, 19);
              String dt = (e["seconds"]/60).toStringAsFixed(1);
              return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(ts, style: styleSessionDate),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text("$dt m", style: styleSessionElapsed),
                    ),
                  ],
              );
            }).toList();
  }

  Widget _lanaDetail() {
    const styleButtonText = TextStyle(fontSize: 20, color: Colors.white);
    const styleInfoListText = TextStyle(fontSize: 16, color: Colors.black);

    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Text(
                  widget.lana['name'],
                  style: styleLanaName,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    "for ${widget.lana['hours']} h/week",
                    style: styleLanaTime,
                  )
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.all(4),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LanaEditView(widget.lana))
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Edit",
                            style: styleButtonText,
                          ),
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.all(4),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LanaRunView(widget.lana))
                          );
                          setState(() {});
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Start",
                            style: styleButtonText,
                          ),
                        ),
                      )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: Text(
                  widget.lana.toString(),
                  style: styleInfoListText,
                )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: FutureBuilder<double>(
                  future: totalLanaRunHours(widget.lana["id"]),
                  builder: (
                      BuildContext context,
                      AsyncSnapshot<double> snapshot,
                  ) {
                    double totalHours = snapshot.data ?? 0;
                    return Text(
                        "Total time: ${totalHours.toStringAsFixed(1)} hours",
                        style: styleInfoListText,
                    );
                  }
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: FutureBuilder<double>(
                    future: totalLanaAgeHours(widget.lana["id"]),
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<double> snapshot,
                        ) {
                      // return Text("Age: ${snapshot.data.toString()} hours");
                      return Text(
                          "Age: ${hoursToHuman(snapshot.data!)}",
                          style: styleInfoListText,
                      );
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: FutureBuilder<double>(
                    future: realWeeklyHours(widget.lana["id"]),
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<double> snapshot,
                        ) {
                      return Text(
                        "Weekly time: ${hoursToHuman(snapshot.data!)}",
                        style: styleInfoListText,
                      );
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: FutureBuilder<double>(
                    future: lagBehind(widget.lana["id"]),
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<double> snapshot,
                        ) {
                      return Text(
                        "Time behind/ahead: ${hoursToHuman(snapshot.data!)}",
                        style: styleInfoListText,
                      );
                    }
                ),
              ),
            ]
        )
    );
  }
}
