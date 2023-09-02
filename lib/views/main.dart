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
