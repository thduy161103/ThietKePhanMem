import 'package:flutter/material.dart';
import '../models/event_detail.dart';
import '../network/events.dart';
import 'dart:developer' as developer;
import 'quiz/quiz_screen.dart'; // Make sure to import the QuizScreen
import 'package:get/get.dart'; // Added import for GetX navigation

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final String eventGame;
  const EventDetailsScreen({Key? key, required this.eventId, required this.eventGame}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Future<EventDetail> _eventDetailFuture;
  final Color primaryColor = Color(0xFFff5c30);

  @override
  void initState() {
    super.initState();
    _eventDetailFuture = EventRequest.fetchEventDetail(widget.eventId);
  }

  void _onPlayButtonTapped(EventDetail event) {
    print("Play button tapped for event: ${event.gameName}");
    if (event.gameName.toLowerCase() == "quiz") {
      Get.to(() => QuizScreen(eventId: widget.eventId));
    } else {
      print("Showing snackbar for unsupported game");
      Get.snackbar(
        'Unsupported Game',
        'This game type is not supported yet.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sự kiện'),
      ),
      body: FutureBuilder<EventDetail>(
        future: _eventDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final event = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    event.tenSuKien,
                    style: TextStyle(color: Colors.white),
                  ),
                  background: Image.network(
                    event.hinhAnh,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.business, 'Thương hiệu', event.brandName),
                      _buildInfoRow(Icons.games, 'Loại game', event.gameName),
                      _buildInfoRow(Icons.card_giftcard, 'Số lượng voucher', event.soLuongVoucher.toString()),
                      SizedBox(height: 16),
                      Text(
                        'Mô tả',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      SizedBox(height: 8),
                      Text(event.moTa),
                      SizedBox(height: 16),
                      _buildInfoRow(Icons.access_time, 'Bắt đầu', event.thoiGianBatDau.toString() ),
                      _buildInfoRow(Icons.access_time, 'Kết thúc', event.thoiGianKetThuc.toString()),
                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => _onPlayButtonTapped(event),
                          icon: Icon(Icons.play_arrow),
                          label: Text('Play Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}