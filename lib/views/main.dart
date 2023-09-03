import 'package:flutter/material.dart';

import '../db.dart';
import 'add_task.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  final String title = "Lanak list";

  @override
  State<MainView> createState() => _MainViewState();
}


class _MainViewState extends State<MainView> {
  final styleTaskListText = const TextStyle(fontSize: 24);
  Future<List<String>> _tasks = getTasks();

  void _addTask() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddTaskView())
    );
  }

  Widget _buildRow(String task) {
    return ListTile(
      leading: const Icon(Icons.access_time, color: Colors.deepOrange),
      title: Text(task, style: styleTaskListText,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(widget.title),
            Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () {
                    _tasks = getTasks();
                    setState(() {});  // this is the 'refresh'
                  },
                  child: const Text("Refresh"),
                ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _tasks,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
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
        onPressed: _addTask,
        tooltip: 'Add task',
        child: const Icon(Icons.ac_unit),
      ),
    );
  }
}