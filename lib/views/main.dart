import 'package:flutter/material.dart';

import '../db.dart';
import 'add_task.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  final String title = "Lanak list";

  @override
  // State<MainView> createState() => _MainViewState();
  State<MainView> createState() => _FutureBuilderExampleState();
}


class _MainViewState extends State<MainView> {
  final styleTaskListText = const TextStyle(fontSize: 24);
  final Future<List<String>> _tasks = getTasks();

  void _addTask() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddTaskView())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _taskList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _taskList() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        for (final task in getTasksOld())
          _buildRow(task)
      ],
    );
  }

  Widget _buildRow(String task) {
    return ListTile(
      leading: const Icon(Icons.access_time, color: Colors.deepOrange),
      title: Text(task, style: styleTaskListText,),
    );
  }
}


class _FutureBuilderExampleState extends State<MainView> {
  final Future<List<String>> _nameList = Future<List<String>>.delayed(
      const Duration(seconds: 10),
        () => ["good", "bad"],
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<List<String>>(
        future: _nameList, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              for (final task in snapshot.data!)
                Text(task)
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
          return Center(
              child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: children,
              )
          );
        },
      ),
    );
  }
}