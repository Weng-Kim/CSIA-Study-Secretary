import 'package:flutter/material.dart';

class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  int workDuration = 25; // Work duration in minutes
  int breakDuration = 5; // Break duration in minutes
  bool isWorking = true; // Track if it's work or break time
  bool isRunning = false; // Timer running state
  int remainingTime = 1500; // Time in seconds (25 minutes)

  late String timerText;

  @override
  void initState() {
    super.initState();
    updateTimerText();
  }

  void updateTimerText() {
    final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingTime % 60).toString().padLeft(2, '0');
    timerText = '$minutes:$seconds';
  }

  void startTimer() {
    setState(() {
      isRunning = true;
    });
    Future.doWhile(() async {
      if (isRunning && remainingTime > 0) {
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          remainingTime--;
          updateTimerText();
        });
        return true;
      }
      if (remainingTime == 0) {
        toggleTimer();
      }
      return false;
    });
  }

  void stopTimer() {
    setState(() {
      isRunning = false;
    });
  }

  void resetTimer() {
    setState(() {
      remainingTime = isWorking ? workDuration * 60 : breakDuration * 60;
      updateTimerText();
      isRunning = false;
    });
  }

  void toggleTimer() {
    setState(() {
      isWorking = !isWorking;
      resetTimer();
      if (!isWorking) {
        showBreakNotification();
      }
    });
  }

  void showBreakNotification() {
    // Add a local notification here (e.g., with FlutterLocalNotificationsPlugin)
    print('Break time started!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isWorking ? 'Work Time' : 'Break Time',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              timerText,
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? null : startTimer,
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: isRunning ? stopTimer : null,
                  child: Text('Stop'),
                ),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 40),
            Text('Break Duration:'),
            Slider(
              value: breakDuration.toDouble(),
              min: 1,
              max: 60,
              divisions: 59,
              label: '$breakDuration minutes',
              onChanged: (value) {
                setState(() {
                  breakDuration = value.toInt();
                  if (!isWorking) resetTimer();
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Work Duration:',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: workDuration.toDouble(),
              min: 1,
              max: 60,
              divisions: 59,
              label: '$workDuration minutes',
              onChanged: (value) {
                setState(() {
                  workDuration = value.toInt();
                  if (isWorking) resetTimer();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
