import 'dart:async';
import 'package:flutter/material.dart';

class Stopwatch extends StatefulWidget {
  const Stopwatch({super.key});

  @override
  State<Stopwatch> createState() => _StopwatchState();
}

class _StopwatchState extends State<Stopwatch> {
  int seconds = 0;
  late Timer timer;

  bool isTicking = false;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), _onTick);
    setState(() {
      isTicking = true;
    });
    print('started');
  }

  void stopTimer() {
    timer.cancel();
    setState(() {
      isTicking = false;
    });
    print('stopped');
  }

  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _onTick(Timer timer) {
    if (mounted) {
      setState(() {
        seconds++;
      });
    }
  }

  void reset() {
    timer.cancel();
    setState(() {
      seconds = 0;
      isTicking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 400,
      height: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255), // สีพื้นหลัง
        borderRadius: BorderRadius.circular(20), // มุมโค้ง 20 หน่วย
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$seconds seconds',
            style: TextStyle(fontSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isTicking ? null : startTimer,
                  child: Text(
                    'Start',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: isTicking ? stopTimer : null,
                  child: Text(
                    'Stop',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: reset,
            child: Text(
              'Reset',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 205, 0, 0)),
          ),
        ],
      ),
    );
  }
}
