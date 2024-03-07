import 'package:flutter/material.dart';

import 'package:lanak/entities.dart';


Widget lanaRow(
    Map<String, dynamic> task,
    BuildContext ctx,
    TaskLoad taskLoad,
    TextStyle style,
    ) {
  final screen = MediaQuery.of(ctx).size;

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
        // _goToLanaDetail(task);
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
                  lag.toStringAsFixed(1),
                  style: style,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                )
            )
          ]
      )
  );
}
