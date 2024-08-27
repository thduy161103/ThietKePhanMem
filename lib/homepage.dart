import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/songlist.dart';
import 'package:coupon_uikit/coupon_uikit.dart';

import 'models/event.dart';


class HomePage extends StatelessWidget {
  //final Function(bool, String, String) onLoginStateChanged;
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Home Page',
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _musicHomePageState();
}
class _musicHomePageState extends State<homePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    home(),
    EventList(), // Modified tab page for Events
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event), // Modified icon for Events
            label: 'Events', // Modified label for Events
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _pages[index];
          },
        );
      },
    );
  }
}

class home extends StatelessWidget {
  home({Key? key});

  final List<Map<String, dynamic>> dummyData = [
    {
      'songName': 'Song 1',
      'author': 'Author 1',
      'likes': 100,
    },
    {
      'songName': 'Song 2',
      'author': 'Author 2',
      'likes': 200,
    },
    {
      'songName': 'Song 3',
      'author': 'Author 3',
      'likes': 300,
    },
  ];





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song List'),
      ),
      body: ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: (BuildContext context, int index) {
          final song = dummyData[index];
          return Padding(
            padding: EdgeInsets.all(8.0), // Add padding
            child: CouponCard(
              firstChild: Row( // Change to Row
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        song['songName'], // Remove unnecessary textDirection
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        song['author'],
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        '${song['likes']} likes',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Keep the secondChild as an empty container
                ],
              ),
              secondChild:Container(),
              border: BorderSide.none, // Remove border color
              curveAxis: Axis.horizontal,
              // Change child widget axis to horizontal
            ),
          );
        },
      ),
    );
  }
}

class EventList extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách sự kiện'),
      ),
      body: ListView.builder(
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
                  backgroundImage: AssetImage(event.imageUrl),
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
      ),
    );
  }
}

// class Event {
//   final String imageUrl;
//   final String companyName;
//   final String eventName;
//   final String endTime;
//
//   Event({
//     required this.imageUrl,
//     required this.companyName,
//     required this.eventName,
//     required this.endTime,
//   });
// }