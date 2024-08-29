import 'dart:async';

import 'package:flutter/material.dart';

class ClickApp extends StatefulWidget {
  @override
  _ClickAppState createState() => _ClickAppState();
}

class _ClickAppState extends State<ClickApp> {
  int _counter = 0;
  bool _gameStarted = false;
  int _countdown = 10;
  Timer? _timer;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _counter = 0;
      _countdown = 10;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _timer?.cancel();
          _gameStarted = false;
          showExchangeDialog();
        }
      });
    });
  }

  void showExchangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đổi vật phẩm'),
          content: Text('Bạn có muốn đổi $_counter lần nhấn lấy phần thưởng không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Logic đổi phần thưởng
                Navigator.of(context).pop();
              },
              child: Text('Đổi'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Click App Demo'),
      ),
      body: Center(
        child: _gameStarted
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  Text('Time left: $_countdown seconds', style: Theme.of(context).textTheme.headlineMedium,),
                  Text('You have pushed the button this many times:',),
                  Text('$_counter', style: Theme.of(context).textTheme.headlineMedium,),
              ],
            )
            : ElevatedButton(
              onPressed: _startGame,
              child: Text('Bắt đầu'),
        ),
      ),
      floatingActionButton: _gameStarted
          ? FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      )
          : null,
    );
  }
}