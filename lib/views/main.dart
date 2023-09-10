import 'package:flutter/material.dart';
import 'package:lanak/views/lana_detail.dart';

import '../db.dart';
import 'add_task.dart';
import 'lana_detail.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  final String title = "Lanak list";

  @override
  State<MainView> createState() => _MainViewState();
}


class _MainViewState extends State<MainView> {
  final styleTaskListText = const TextStyle(fontSize: 24);
  Future<List<Map<String, dynamic>>> _tasks = getTasks();

  void _goToLanaAdd() async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddTaskView())
    );
    // We refresh the list:
    _tasks = getTasks();
    setState(() {});
  }
  
  void _goToLanaDetail(Map<String, dynamic> lana) async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LanaDetailView(lana))
    );
    // We refresh the list:
    _tasks = getTasks();
    setState(() {});
  }

  Widget _buildRow(Map<String, dynamic> task) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue[100],
        elevation: 3,
      ),
      onPressed: () {
        _goToLanaDetail(task);
      },
      child: Text(task["name"], style: styleTaskListText)
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
            children = <Widget>[
              for (final task in snapshot.data!)
                _buildRow(task)
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