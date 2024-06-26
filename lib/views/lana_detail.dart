import 'package:flutter/material.dart';

import 'package:lanak/process.dart';
import 'package:lanak/views/lana_edit.dart';
import 'package:lanak/views/lana_run.dart';
import 'package:lanak/db.dart';


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
                    "for ${(widget.lana['projected']*60).toStringAsFixed(0)} min/week",
                    style: styleLanaTime,
                  )
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.all(4),
                          shape: const StadiumBorder(),
                          minimumSize: const Size(100, 40),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LanaEditView(widget.lana))
                          );
                        },
                        child: const Text("Edit", style: styleButtonText),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.all(4),
                          shape: const StadiumBorder(),
                          minimumSize: const Size(100, 40),
                        ),
                        onPressed: () async {
                          deleteLana(widget.lana);
                          Navigator.pop(context);
                        },
                        child: const Text("Delete", style: styleButtonText),
                      )
                  ),
                ],
              ),
            ]
        )
    );
  }
}
