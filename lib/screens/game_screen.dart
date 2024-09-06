import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _counter = 0;
  bool _gameStarted = false;

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _counter = 0;
    });
  }

  void _incrementCounter() {
    if (_gameStarted) {
      setState(() {
        _counter++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Screen'),
      ),
      body: GestureDetector(
        onTap: _incrementCounter,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!_gameStarted)
                ElevatedButton(
                  onPressed: _startGame,
                  child: Text('Start Game'),
                ),
              if (_gameStarted)
                Text(
                  'Counter: $_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
            ],
          ),
        ),
      ),
    );
  }
}