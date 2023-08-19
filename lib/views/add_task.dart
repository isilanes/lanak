import 'package:flutter/material.dart';

import '../db.dart';


class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  final String title = "Add task";

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}


class _AddTaskViewState extends State<AddTaskView> {
  final styleTaskDetailText = const TextStyle(fontSize: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text(widget.title),
      ),
      body: _taskDetail(),
    );
  }

  Widget _taskDetail() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Whatever"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Go back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
