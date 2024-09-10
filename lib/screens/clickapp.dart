import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:musicapp/network/point.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/voucher.dart';
import 'homepage.dart';

class ClickApp extends StatefulWidget {
  final String eventId;
  final String gameId;
  const ClickApp({Key? key, required this.eventId, required this.gameId}) : super(key: key);

  @override
  _ClickAppState createState() => _ClickAppState();
}

class _ClickAppState extends State<ClickApp> with SingleTickerProviderStateMixin {
  String eventId = '';
  int _counter = 0;
  bool _gameStarted = false;
  int _countdown = 10;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

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

  void _incrementCounter() {
    if (!_gameStarted) return;
    setState(() {
      _counter++;
    });
    _animationController.forward().then((_) => _animationController.reverse());
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
          _endGame();
        }
      });
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() {
      _gameStarted = false;
    });
    showExchangeDialog();
  }

  void showExchangeDialog() async {
    // int voucherQuantity = (_counter / 10).floor();

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

    bool success = await PointRequest.updatePoint(userId, widget.gameId, widget.eventId, _counter, _counter);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Chúc mừng!' : 'Thông báo'),
          content: Text(
            success
                ? 'Bạn đã giành được thêm ${_counter} điểm!'
                : 'Có lỗi xảy ra khi cập nhật điểm. Vui lòng thử lại sau.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
                );
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
            colors: [Colors.blue.shade300, Colors.purple.shade300],
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
          'Clicks:',
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
        Text(
          '$_counter',
          style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 40),
        ScaleTransition(
          scale: _animation,
          child: GestureDetector(
            onTap: _incrementCounter,
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
                child: Icon(Icons.touch_app, size: 80, color: Colors.blue.shade300),
              ),
            ),
          ),
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
          'Start Game',
          style: TextStyle(fontSize: 24),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }
}