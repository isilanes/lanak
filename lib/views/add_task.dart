import 'package:flutter/material.dart';

import '../db.dart';


class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  final String title = "Add Lanak";

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}


class _AddTaskViewState extends State<AddTaskView> {
  final styleTaskDetailText = const TextStyle(fontSize: 24);
  final lanakNameController = TextEditingController();
  final lanakHoursController = TextEditingController();

  @override
  void dispose() {
    lanakNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
                controller: lanakNameController,
              )
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Lanak hours per week",
                ),
                controller: lanakHoursController,
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
                  saveTask(
                    context,
                    lanakNameController.text,
                    lanakHoursController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Submit"),
            )
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  deleteLanaDatabase();
                  print("db dropped!");
                },
                child: const Text("DROP DB"),
              )
          )
        ],
      )
    );
  }
}
