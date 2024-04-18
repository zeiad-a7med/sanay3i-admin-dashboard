import 'dart:async';
import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int hours = 00;
  int minutes = 0;
  int seconds = 0;
  bool isRunning = false;
  Timer? timer;

  void startTimer() {
    isRunning = true;
    timer = Timer.periodic(Duration(milliseconds:10 ), (timer) {
      setState(() {
        seconds++;
        if (seconds == 60){
          seconds = 0;
          minutes++;
        }
        if (minutes == 60) {
          minutes = 0;
          seconds=0;
          hours++;
        }
        if (hours < 0) {
          timer.cancel();
          isRunning = false;
        }
      });
    });
  }

  void stopTimer() {
    if (timer != null) {
      timer!.cancel();
      isRunning = false;
    }
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 50),
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (!isRunning) {
                    startTimer();
                  }
                },
                child: Text('Start'),
              ),
              ElevatedButton(
                onPressed: () {
                  stopTimer();
                  setState(() {
                    hours = 0;
                    minutes = 0;
                    seconds = 0;
                  });
                },
                child: Text('Reset'),
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: '0',
                  decoration: InputDecoration(
                    labelText: 'Hours',
                  ),
                  onChanged: (value) {
                    setState(() {
                      hours = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: '0',
                  decoration: InputDecoration(
                    labelText: 'Minutes',
                  ),
                  onChanged: (value) {
                    setState(() {
                      minutes = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: '0',
                  decoration: InputDecoration(
                    labelText: 'Seconds',
                  ),
                  onChanged: (value) {
                    setState(() {
                      seconds = int.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}