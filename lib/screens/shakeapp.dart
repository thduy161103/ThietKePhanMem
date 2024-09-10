import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../network/point.dart';
import '../network/voucher.dart';
import 'homepage.dart';

class ShakeApp extends StatefulWidget {
  final String eventId;
  final String gameId;
  const ShakeApp({Key? key, required this.eventId, required this.gameId}) : super(key: key);

  @override
  State<ShakeApp> createState() => _ShakeAppState();
}

class _ShakeAppState extends State<ShakeApp> with SingleTickerProviderStateMixin {
  int shakeCount = 0;
  bool _gameStarted = false;
  int _countdown = 10;
  Timer? _timer;
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  final double shakeThreshold = 2.7;
  late String eventId;
  late AnimationController _animationController;
  late Animation<double> _animation;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    eventId = widget.eventId;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(_animationController);
  }

  void _startGame() {
    setState(() {
      _gameStarted = true;
      shakeCount = 0;
      _countdown = 10;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          _endGame();
        }
      });
    });

    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      if (!_gameStarted) return;
      double deltaX = (event.x - _lastX).abs();
      double deltaY = (event.y - _lastY).abs();
      double deltaZ = (event.z - _lastZ).abs();
      if (deltaX > shakeThreshold || deltaY > shakeThreshold || deltaZ > shakeThreshold) {
        setState(() {
          shakeCount++;
        });
        _animationController.forward().then((_) => _animationController.reverse());
      }
      _lastX = event.x;
      _lastY = event.y;
      _lastZ = event.z;
    });
  }

  void _endGame() {
    _timer?.cancel();
    _accelerometerSubscription?.cancel();
    setState(() {
      _gameStarted = false;
    });
    showExchangeDialog();
  }

  void showExchangeDialog() async {
    // int voucherQuantity = (shakeCount / 10).floor();
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('accessToken');
    // Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    // String userId = decodedToken['id'] as String;
    // List<Map<String, dynamic>> voucherIds = await VoucherRequest.fetchVoucherForEvent(eventId);
    // bool success = await VoucherRequest.updateVoucherAfterGame(userId, voucherIds[0]['id'], voucherQuantity, voucherIds[0]['point']);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    String userId = decodedToken['id'] as String;

    bool success = await PointRequest.updatePoint(userId, widget.gameId, widget.eventId, shakeCount, shakeCount);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Chúc mừng!' : 'Thông báo'),
          content: Text(
            success
                ? 'Bạn đã giành được thêm ${shakeCount} điểm!'
                : 'Có lỗi xảy ra khi cập nhật điểm. Vui lòng thử lại sau.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
                ); // Chuyển đến HomePage
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _accelerometerSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade300, Colors.teal.shade300],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: _gameStarted ? _buildGameUI() : _buildStartButton(),
          ),
        ),
      ),
    );
  }

  Widget _buildGameUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Time left: $_countdown seconds',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 20),
        Text(
          'Shakes:',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        Text(
          '$shakeCount',
          style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 40),
        ScaleTransition(
          scale: _animation,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.vibration, size: 80, color: Colors.green.shade300),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'Shake your device!',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: _startGame,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Text(
          'Start Shaking',
          style: TextStyle(fontSize: 24),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }
}

