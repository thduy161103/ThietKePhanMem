import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class ShakeApp extends StatefulWidget {
  const ShakeApp({super.key});

  @override
  State<ShakeApp> createState() => _ShakeAppState();
}

class _ShakeAppState extends State<ShakeApp> {
  int shakeCount = 0;
  bool _gameStarted = false;
  int _countdown = 10;
  List<Reward> rewards = [];
  List<Item> inventory = [];
  Timer? _timer;
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  final double shakeThreshold = 2.7;

  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu ban đầu
    rewards.add(Reward("Tai nghe Bluetooth", "Tai nghe Bluetooth chất lượng cao", 100));
    inventory.add(Item("Tai nghe", "Tai nghe thông thường", 10));
    // ... thêm các vật phẩm khác
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      shakeCount = 0;
      _countdown = 60;
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

    accelerometerEvents.listen((AccelerometerEvent event) {
      double deltaX = (event.x - _lastX).abs();
      double deltaY = (event.y - _lastY).abs();
      double deltaZ = (event.z - _lastZ).abs();
      if (deltaX > shakeThreshold || deltaY > shakeThreshold || deltaZ > shakeThreshold) {
        setState(() {
          shakeCount++;
        });
      }
      _lastX = event.x;
      _lastY = event.y;
      _lastZ = event.z;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void showExchangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đổi vật phẩm'),
          content: Text('Bạn có muốn đổi $shakeCount lần lắc lấy phần thưởng không?'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lắc để đổi thưởng'),
      ),
      body: Center(
        child: _gameStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text('Thời gian còn lại: $_countdown giây'),
                    Text('Số lần lắc: $shakeCount'),
                    Expanded(
                        child: ListView.builder(
                            itemCount: rewards.length + inventory.length,
                            itemBuilder: (context, index) {
                              if (index < rewards.length) {
                                return ListTile(
                                  title: Text(rewards[index].name),
                                  subtitle: Text(rewards[index].description),
                              );
                              } else {
                                return ListTile(
                                  title: Text(inventory[index - rewards.length].name),
                                  subtitle: Text(inventory[index - rewards.length].description),
                                );
                              }
                            },
                        ),
                    ),
                    // ElevatedButton(
                    //     onPressed: showExchangeDialog,
                    //     child: Text('Đổi vật phẩm'),
                    // ),
              ],
            )
            : ElevatedButton(
                onPressed: _startGame,
                child: Text('Bắt đầu'),
            ),
      ),
    );
  }
}

class Reward {
  final String name;
  final String description;
  final int value;

  Reward(this.name, this.description, this.value);
}

class Item {
  final String name;
  final String description;
  final int value;

  Item(this.name, this.description, this.value);
}

