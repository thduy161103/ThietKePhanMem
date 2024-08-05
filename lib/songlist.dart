import 'package:flutter/material.dart';

class Songlist extends StatefulWidget {
  const Songlist({Key? key}) : super(key: key);

  @override
  State<Songlist> createState() => _SonglistState();
}
class _SonglistState extends State<Songlist> {
  List<String> songs = [
    'Song 1',
    'Song 2',
    'Song 3',
    'Song 4',
    'Song 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Song List'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(songs[index]),
          );
        },
      ),
    );
  }
}