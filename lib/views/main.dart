import 'package:flutter/material.dart';

import 'package:lanak/process.dart';
import 'package:lanak/views/lana_edit.dart';
import 'package:lanak/views/lana_detail.dart';


class TaskLoad {
  double nTasks;
  double totalHours;

  TaskLoad({
    this.nTasks = 0,
    this.totalHours = 0,
  });

  void reset() {
    nTasks = 0;
    totalHours = 0;
  }

  void addTask(Map<String, dynamic> task) {
    nTasks += 1;
    totalHours += task["hours"] ?? 0;
  }
}


class MainView extends StatefulWidget {
  const MainView({super.key});

  final String title = "Lanak list";

  @override
  State<MainView> createState() => _MainViewState();
}


class _MainViewState extends State<MainView> {
  final styleTaskListText = const TextStyle(fontSize: 24, color: Colors.white);
  Future<List<Map<String, dynamic>>> _tasks = getLanakWithLag();
  TaskLoad taskLoad = TaskLoad();

  void _goToLanaAdd() async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LanaEditView({}))
    );
    // We refresh the list:
    _tasks = getLanakWithLag();
    setState(() {});
  }
  
  void _goToLanaDetail(Map<String, dynamic> lana) async {
    await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LanaDetailView(lana))
    );
    // We refresh the list:
    _tasks = getLanakWithLag();
    setState(() {});
  }

  Widget _titleRow() {
    const Color color = Colors.blueAccent;
    const styleTitle = TextStyle(fontSize: 20, color: color);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        "${taskLoad.nTasks} tasks, ${taskLoad.totalHours} total hours",
        style: styleTitle,
      )
    );
  }

  Widget _buildRow(Map<String, dynamic> task) {
    final screen = MediaQuery.of(context).size;
    final lag = task["lag"];
    Color color = Colors.deepOrange;
    if (lag < 0) {
      color = Colors.lightGreen;
    }
    taskLoad.addTask(task);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 3,
      ),
      onPressed: () {
        _goToLanaDetail(task);
      },
      child: Row(
        children: [
          SizedBox(
            width: screen.width * 0.55,
            child: Text(
              task['name'],
              style: styleTaskListText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "|",
            style: styleTaskListText,
          ),
          SizedBox(
              width: screen.width * 0.20,
              child: Text(
                lag.toStringAsFixed(1),
                style: styleTaskListText,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              )
          )
        ]
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
      body: Column(
        children: <Widget>[
          _titleRow(),
          FutureBuilder<List<Map<String, dynamic>>>(
              future: _tasks,
              builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
              ) {
                List<Widget> children;
                taskLoad.reset();
                // taskLoad.nTasks = 0;
                // taskLoad.totalHours = 0;
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
                return Expanded(
                    child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16.0),
                    children: children,
                  )
                );
              }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToLanaAdd,
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }
}