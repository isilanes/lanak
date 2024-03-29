import 'package:flutter/material.dart';

import '../db.dart';
import 'main.dart';


class LanaEditView extends StatefulWidget {
  final Map<String, dynamic> lana;

  const LanaEditView(this.lana, {super.key});

  @override
  State<LanaEditView> createState() => _LanaEditViewState();
}

class _LanaEditViewState extends State<LanaEditView> {
  final styleTaskDetailText = const TextStyle(fontSize: 24);
  final lanakNameController = TextEditingController();
  final lanakMinutesController = TextEditingController();

  @override
  void dispose() {
    lanakNameController.dispose();
    super.dispose();
  }

  String _title() {
    if (widget.lana.containsKey("id")) {
      return "Edit Lana";
    } else {
      return "Add Lana";
    }
  }

  String _defaultLanaName () {
    if (widget.lana.containsKey("name")) {
      return widget.lana["name"];
    } else {
      return "";
    }
  }

  String _defaultLanaMinutes () {
    if (widget.lana.containsKey("projected")) {
      return (widget.lana["projected"]*60).toStringAsFixed(0);
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title()),
      ),
      body: _taskDetail(),
    );
  }

  Widget _taskDetail() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Lanak name",
                ),
                controller: lanakNameController..text = _defaultLanaName(),
              )
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Lanak minutes per week",
                ),
                controller: lanakMinutesController..text = _defaultLanaMinutes(),
              )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[100],
                elevation: 3,
              ),
                onPressed: () {
                  int lanaId = -1;  // -1 = creation, else update
                  if (widget.lana.containsKey("id")) {
                      lanaId = widget.lana["id"];
                  }
                  saveLana(
                      context,
                      lanaId,
                      lanakNameController.text,
                      lanakMinutesController.text,
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainView())
                  );
                },
                child: const Text("Submit"),
            )
          ),
          // Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     child: ElevatedButton(
          //       onPressed: () {
          //         deleteLanaDatabase();
          //       },
          //       child: const Text("DROP DB"),
          //     )
          // )
        ],
      )
    );
  }
}
