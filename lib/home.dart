import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp/songlist.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
class MusicHome extends StatelessWidget {
  const MusicHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Music Player',
      home: musicHomePage(),
    );
  }
}

class musicHomePage extends StatefulWidget {
  const musicHomePage({Key? key}) : super(key: key);

  @override
  State<musicHomePage> createState() => _musicHomePageState();
}
class _musicHomePageState extends State<musicHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    homePage(),
    Center(child: Text('Events')), // Modified tab page for Events
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

class homePage extends StatelessWidget {
   homePage({Key? key});

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