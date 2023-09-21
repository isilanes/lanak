import 'package:flutter/material.dart';
import 'package:lanak/db.dart';

import 'lana_edit.dart';
import 'lana_run.dart';


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
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LanaEditView(widget.lana))
                          );
                        },
                        child: const Text("Edit"),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LanaRunView(widget.lana))
                          );
                          setState(() {});
                        },
                        child: const Text("Start"),
                      )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FutureBuilder<List<Widget>>(
                  future: _events(),
                  builder: (
                      BuildContext context,
                      AsyncSnapshot<List<Widget>> snapshot,
                  ) {
                    List<Widget> children;
                    children = snapshot.data ?? [];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    );
                  }
                )
              ),
            ]
        )
    );
  }
}
