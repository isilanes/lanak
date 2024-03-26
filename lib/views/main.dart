import 'package:flutter/material.dart';
import 'package:lanak/components/lists.dart';

import 'package:lanak/process.dart';
import 'package:lanak/views/lana_edit.dart';
import 'package:lanak/views/lana_detail.dart';
import 'package:lanak/entities.dart';


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

  Widget titleRow() {
    const Color nTasksColor = Colors.blueAccent;
    const Color totalHoursColor = Colors.purple;
    Color behindHoursColor = Colors.red;
    IconData behindHoursIconData = Icons.dangerous_outlined;
    const double textSize = 32;
    const nTasksStyle = TextStyle(fontSize: textSize, color: nTasksColor);
    const totalHoursStyle = TextStyle(fontSize: textSize, color: totalHoursColor);
    var behindHoursStyle = TextStyle(fontSize: textSize, color: behindHoursColor);

    return FutureBuilder(
        future: _tasks,
        builder: (
            BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
        ) {
            taskLoad.reset();
            for (final lanaDict in snapshot.data!) {
                taskLoad.addTask(lanaDict);
            }
            if (taskLoad.behindHours < 0) {
              behindHoursColor = Colors.lightGreen;
              behindHoursIconData = Icons.check_circle_outline;
              behindHoursStyle = TextStyle(fontSize: textSize, color: behindHoursColor);
            }
            return Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(taskLoad.nTasks.toStringAsFixed((0)), style: nTasksStyle,),
                      const Icon(Icons.density_small, size: textSize, color: nTasksColor),
                    ],
                  ),
                  const SizedBox(width: 16,),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text("${taskLoad.totalHours.toStringAsFixed((1))}h", style: totalHoursStyle,),
                      const Icon(Icons.bolt, size: textSize, color: totalHoursColor),
                    ],
                  ),
                  const SizedBox(width: 16,),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text("${(taskLoad.behindHours*60).toStringAsFixed(0)}m",  style: behindHoursStyle,),
                      Icon(behindHoursIconData, size: textSize, color: behindHoursColor),
                    ],
                  ),
                ]
            ),
          );
        }
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
          titleRow(),
          FutureBuilder<List<Map<String, dynamic>>>(
              future: _tasks,
              builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
              ) {
                List<Widget> children;
                taskLoad.reset();
                if (snapshot.hasData) {
                  children = <Widget>[
                    for (final task in snapshot.data!)
                      Row(
                          children: <Widget>[
                            lanaRow(task, context, taskLoad, styleTaskListText),
                            IconButton(
                              onPressed: () {
                                _goToLanaDetail(task);
                              },
                              icon: const Icon(Icons.settings, size: 35),
                            )
                          ]
                      )
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