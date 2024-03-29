import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../db.dart';
import 'package:lanak/main.dart';


class LanaRunView extends StatefulWidget {
    final Map<String, dynamic> lana;
    final StatefulWidget homePage;

    const LanaRunView(this.lana, this.homePage, {super.key});

    @override
    State<LanaRunView> createState() => _LanaRunViewState();
}

class _LanaRunViewState extends State<LanaRunView> {
  final styleTimeDisplayText = const TextStyle(
      fontSize: 48,
      fontFamily: 'Helvetica',
      fontWeight: FontWeight.bold,
  );
  final styleButtonText = const TextStyle(fontSize: 20, color: Colors.white);
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  int elapsedMilliseconds = 0;
  String _currentPauseButtonText = "Start";
  bool _isTimerRunning = false;
  Color _currentPauseButtonColor = Colors.green;

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Active: ${widget.lana['name']}"),
      ),
      body: _lanaStopWatch(),
    );
  }

  Widget _streamTime() {
    return StreamBuilder<int>(
      stream: _stopWatchTimer.rawTime,
      initialData: 0,
      builder: (context, snap) {
        final value = snap.data!.toInt();
        final displayTime = StopWatchTimer.getDisplayTime(value);
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                displayTime,
                style: styleTimeDisplayText,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _lanaStopWatch() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 64, 16, 24),
          child: _streamTime(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentPauseButtonColor,
                  padding: const EdgeInsets.all(4),
                  shape: const StadiumBorder(),
                  minimumSize: const Size(100, 40),
                ),
                onPressed: () async {
                  setState(() {
                    if (_isTimerRunning) {
                        _stopWatchTimer.onStopTimer();
                        elapsedMilliseconds = _stopWatchTimer.rawTime.value;
                        _isTimerRunning = false;
                        _currentPauseButtonText = "Start";
                        _currentPauseButtonColor = Colors.green;
                    } else {
                        _stopWatchTimer.onStartTimer();
                        _isTimerRunning = true;
                        _currentPauseButtonText = "Pause";
                        _currentPauseButtonColor = Colors.red;
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    _currentPauseButtonText,
                    style: styleButtonText,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.all(4),
                  shape: const StadiumBorder(),
                  minimumSize: const Size(100, 40),
                ),
                onPressed: () {
                  _stopWatchTimer.onStopTimer();
                  _stopWatchTimer.onResetTimer();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Reset',
                    style: styleButtonText,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.all(4),
                  shape: const StadiumBorder(),
                  minimumSize: const Size(100, 40),
                ),
                onPressed: () {
                  saveSession(
                      context,
                      widget.lana["id"],
                      DateTime.now().toString(),
                      elapsedMilliseconds/1000,
                  );
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => widget.homePage)
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Save',
                    style: styleButtonText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
