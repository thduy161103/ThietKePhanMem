import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/songlist.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'drawer.dart';

import '../models/event.dart';
import '../network/events.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Event> events = [
    // Danh sách các sự kiện mẫu
    Event(
      imageUrl: 'assets/images/company1.png',
      companyName: 'Công ty A',
      eventName: 'Trò chơi may mắn',
      endTime: '31/12/2023',
    ),
    // Thêm các sự kiện khác vào đây
  ];

  late Future<List<Event>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = EventRequest.fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sự kiện'),
      ),
      drawer: MyDrawer(),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load events'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events available'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(event.imageUrl),
                    ),
                    title: Text(event.companyName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.eventName),
                        Text('Kết thúc: ${event.endTime}'),
                      ],
                    ),
                    trailing: CircularProgressIndicator(
                      value: 0.5, // Thay đổi giá trị để hiển thị tiến độ
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
