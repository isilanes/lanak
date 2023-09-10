import 'package:flutter/material.dart';

import 'lana_edit.dart';


class LanaDetailView extends StatefulWidget {
  final Map<String, dynamic> lana;

  const LanaDetailView(this.lana, {super.key});

  final String title = "Lana detail";

  @override
  State<LanaDetailView> createState() => _LanaDetailViewState();
}


class _LanaDetailViewState extends State<LanaDetailView> {
  final _styleLanaName = const TextStyle(fontSize: 32);
  final _styleLanaTime = const TextStyle(
    fontSize: 20,
    color: Colors.brown,
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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 16,
              ),
              child: Text(
                widget.lana['name'],
                style: _styleLanaName,
              ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                "for ${widget.lana['hours']} h/week",
                style: _styleLanaTime,
              )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
        ],
      )
    );
  }
}
