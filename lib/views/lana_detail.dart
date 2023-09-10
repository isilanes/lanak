import 'package:flutter/material.dart';

import '../db.dart';


class LanaDetailView extends StatefulWidget {
  final Map<String, dynamic> lana;

  const LanaDetailView(this.lana, {super.key});

  final String title = "Lana detail";

  @override
  State<LanaDetailView> createState() => _LanaDetailViewState(this.lana);
}


class _LanaDetailViewState extends State<LanaDetailView> {
  final Map<String, dynamic> lana;
  final _styleLanaName = const TextStyle(fontSize: 32);
  final _styleLanaTime = const TextStyle(
    fontSize: 20,
    color: Colors.brown,
  );

  _LanaDetailViewState(this.lana);

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
                lana['name'],
                style: _styleLanaName,
              ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                "for ${lana['hours']} h/week",
                style: _styleLanaTime,
              )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Edit"),
            )
          ),
        ],
      )
    );
  }
}
