import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../db.dart';
import 'main.dart';


class LanaRunView extends StatefulWidget {
  final Map<String, dynamic> lana;

  const LanaRunView(this.lana, {super.key});

  @override
  State<LanaRunView> createState() => _LanaRunViewState();
}

class _LanaRunViewState extends State<LanaRunView> {
  final styleTaskDetailText = const TextStyle(fontSize: 24);
  final _title = "Running";
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void dispose() async {
    await _stopWatchTimer.dispose();
    super.dispose();
  }

  String _defaultLanaName () {
    if (widget.lana.containsKey("name")) {
      return widget.lana["name"];
    } else {
      return "";
    }
  }

  String _defaultLanaHours () {
    if (widget.lana.containsKey("hours")) {
      return widget.lana["hours"].toString();
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title),
      ),
      body: _lanaStopWatch(),
    );
  }

  Widget _lanaStopWatch() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.all(4),
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                // CountUpTimerPage.navigatorPush(context);
                _stopWatchTimer.onResetTimer();
                _stopWatchTimer.onStartTimer();
                print(_stopWatchTimer.isRunning);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Start',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.all(4),
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                // CountDownTimerPage.navigatorPush(context);
                _stopWatchTimer.onStopTimer();
                print(_stopWatchTimer.isRunning);
                print(_stopWatchTimer.secondTime.value);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Stop',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
