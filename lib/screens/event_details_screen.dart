import 'package:flutter/material.dart';
import '../models/event_detail.dart';
import '../models/game_detail.dart';
import '../network/events.dart';
import 'dart:developer' as developer;
import 'clickapp.dart';
import 'quiz/quiz_screen.dart';
import 'package:get/get.dart';
import 'shakeapp.dart';
import 'in_app_browser_screen.dart'; // Add this import at the top of the file

import '../network/user_api.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final String eventGame;
  const EventDetailsScreen({Key? key, required this.eventId, required this.eventGame}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late Future<EventDetail> _eventDetailFuture;
  Future<GameDetail>? _gameDetailFuture;
  final Color primaryColor = Color(0xFFff5c30);

  @override
  void initState() {
    super.initState();
    _eventDetailFuture = EventRequest.fetchEventDetail(widget.eventId);
    _eventDetailFuture.then((eventDetail) {
      setState(() {
        _gameDetailFuture = EventRequest.fetchGameDetail(eventDetail.idGame);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<EventDetail>(
        future: _eventDetailFuture,
        builder: (context, eventSnapshot) {
          if (eventSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (eventSnapshot.hasError) {
            return _buildErrorWidget(eventSnapshot.error);
          } else if (!eventSnapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final event = eventSnapshot.data!;
          return FutureBuilder<GameDetail>(
            future: _gameDetailFuture,
            builder: (context, gameSnapshot) {
              if (gameSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (gameSnapshot.hasError) {
                return _buildErrorWidget(gameSnapshot.error);
              }

              final gameDetail = gameSnapshot.data;
              return CustomScrollView(
                slivers: [
                  _buildSliverAppBar(event, gameDetail),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  _buildEventDetails(event, gameDetail),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  _buildPlayButton(event, gameDetail),
                  SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(EventDetail event, GameDetail? gameDetail) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              event.hinhAnh,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetails(EventDetail event, GameDetail? gameDetail) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildSection('Event Details', [
          _buildInfoRow(Icons.business, 'Thương hiệu', event.brandName),
          _buildInfoRow(Icons.card_giftcard, 'Số lượng voucher', event.soLuongVoucher.toString()),
          _buildInfoRow(Icons.access_time, 'Bắt đầu', _formatDateTime(event.thoiGianBatDau)),
          _buildInfoRow(Icons.access_time, 'Kết thúc', _formatDateTime(event.thoiGianKetThuc)),
        ]),
        if (gameDetail != null) ...[
          _buildSection('Game Details', [
            _buildInfoRow(Icons.games, 'Game', gameDetail.name),
            _buildInfoRow(Icons.category, 'Game Type', gameDetail.type),
            _buildInfoRow(Icons.info_outline, 'Instructions', gameDetail.instructions),
          ]),
        ],
        _buildSection('Mô tả', [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(event.moTa),
          ),
        ]),
      ]),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
          ),
        ),
        ...children,
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryColor),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(EventDetail event, GameDetail? gameDetail) {
    return SliverToBoxAdapter(
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () => _onPlayButtonTapped(event, gameDetail),
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
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _eventDetailFuture = EventRequest.fetchEventDetail(widget.eventId);
              });
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  void _onPlayButtonTapped(EventDetail event, GameDetail? gameDetail) async {
    developer.log("Play button tapped for event: ${event.tenSuKien}");
    try {
      if (gameDetail != null) {
        switch (gameDetail.name.toLowerCase()) {
          case "quiz game":
            Get.to(() => QuizScreen(eventId: widget.eventId, gameId: gameDetail.id));
            break;
          case "click game":
            Get.to(() => ClickApp(eventId: widget.eventId, gameId: gameDetail.id));
            break;
          case "shake game":
            Get.to(() => ShakeApp(eventId: widget.eventId, gameId: gameDetail.id));
            break;
          case "trivia game":
            String userId = await UserApi.getCurrentUserId();
            String triviaUrl = 'http://10.0.2.2:6969/player?userId=$userId';
            Get.to(() => InAppBrowserScreen(url: triviaUrl));
            break;
          default:
            developer.log("Unsupported game type");
            Get.snackbar(
              'Unsupported Game',
              'This game type is not supported yet.',
              snackPosition: SnackPosition.BOTTOM,
            );
        }
      } else {
        Get.snackbar(
          'Game Not Found',
          'Unable to find game details.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      developer.log('Error in _onPlayButtonTapped: $e');
      Get.snackbar(
        'Error',
        'Unable to start the game. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}