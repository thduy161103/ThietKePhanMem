import 'package:flutter/material.dart';

import 'drawer.dart';

class MyRewardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Rewards'),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Text('List of rewards will be displayed here'),
      ),
    );
  }
}