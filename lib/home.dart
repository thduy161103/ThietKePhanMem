import 'package:flutter/material.dart';

class HomePage1 extends StatefulWidget {
  final Function(bool, String, String) onLoginStateChanged;

  const HomePage1({required this.onLoginStateChanged, Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
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
        title: const Text('Song List'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Handle drawer item 1 tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Handle drawer item 2 tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Call the updateUserLoginState function to log out
                  widget.onLoginStateChanged(false, '', '');

                  // Navigate back to the login screen or home screen
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          final song = dummyData[index];
          return ListTile(
            title: Text(song['songName']),
            subtitle: Text('Author: ${song['author']}'),
            trailing: Text('Likes: ${song['likes']}'),
          );
        },
      ),
    );
  }
}