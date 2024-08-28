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
  int remainingTime = 60;
  List<Reward> rewards = [];
  List<Item> inventory = [];
  late Timer _timer;
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  final double shakeThreshold = 2.7;

  @override
  void initState() {
    super.initState();
    // Khởi tạo dữ liệu ban đầu
    rewards.add(Reward("Tai nghe Bluetooth", "Tai nghe Bluetooth chất lượng cao", 100));
    inventory.add(Item("Tai nghe", "Tai nghe thông thường", 10));
    // ... thêm các vật phẩm khác
    startTimer();
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

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Số lần lắc: $shakeCount'),
            Text('Thời gian còn lại: $remainingTime giây'),
            // Hiển thị danh sách phần thưởng và vật phẩm
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
            // Nút đổi vật phẩm
            ElevatedButton(
              onPressed: () {
                // Hiển thị dialog để đổi vật phẩm
              },
              child: Text('Đổi vật phẩm'),
            ),
          ],
        ),
      ),
    );
  }

// ... các hàm khác tương tự như trong code Kotlin
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

