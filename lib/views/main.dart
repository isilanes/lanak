import 'package:flutter/material.dart';

import 'package:lanak/process.dart';
import 'package:lanak/views/lana_edit.dart';
import 'package:lanak/views/lana_detail.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  final String title = "Lanak list";

  @override
  State<MainView> createState() => _MainViewState();
}


class _MainViewState extends State<MainView> {
  final styleTaskListText = const TextStyle(fontSize: 24);
  // final Future<List<Map<String, dynamic>>> _tasks = getTasks();
  final Future<List<Map<String, dynamic>>> _tasks = getLanakWithLag();

  void _goToLanaAdd() async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LanaEditView({}))
    );
    // We refresh the list:
    setState(() {});
  }
  
  void _goToLanaDetail(Map<String, dynamic> lana) async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LanaDetailView(lana))
    );
    // We refresh the list:
    setState(() {});
  }

  Widget _buildRow(Map<String, dynamic> task, double lagHours) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue[100],
        elevation: 3,
      ),
      onPressed: () {
        _goToLanaDetail(task);
      },
      child: Text(
        "${task['name']} | ${task['lag']}",
          style: styleTaskListText,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tasks,
        builder: (
            BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
        ) {
          List<Widget> children;
          if (snapshot.hasData) {
            double lagHours = 666.0;
            children = <Widget>[
              for (final task in snapshot.data!)
                _buildRow(task, lagHours)
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Text("error"),
              const Text("death"),
            ];
          } else {
            children = <Widget>[
              const Text("waiting for"),
              const Text("taskList"),
            ];
          }
          return ListView(
              padding: const EdgeInsets.all(16.0),
              children: children,
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToLanaAdd,
        tooltip: 'Add task',
        child: const Icon(Icons.ac_unit),
      ),
    );
  }
}