import 'package:flutter/material.dart';

import 'package:lanak/entities.dart';
import 'package:lanak/views/lana_run.dart';


Widget lanaRow(
    Map<String, dynamic> task,
    BuildContext ctx,
    TaskLoad taskLoad,
    TextStyle style,
    ) {
  final screen = MediaQuery.of(ctx).size;

  final lagMinutes = task["lag"]*60;
  Color color = Colors.deepOrange;
  if (lagMinutes < 0) {
    color = Colors.lightGreen;
  }
  taskLoad.addTask(task);

  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 3,
      ),
      onPressed: () {
        Navigator.push(
            ctx,
            MaterialPageRoute(builder: (context) => LanaRunView(task))
        );
      },
      child: Row(
          children: [
            SizedBox(
              width: screen.width * 0.50,
              child: Text(
                task['name'],
                style: style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              "|",
              style: style,
            ),
            SizedBox(
                width: screen.width * 0.15,
                child: Text(
                  lagMinutes.toStringAsFixed(0),
                  style: style,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                )
            )
          ]
      )
  );
}
