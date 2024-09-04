import 'package:flutter/material.dart';
import 'package:musicapp/songlist.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'clickapp.dart';
import 'drawer.dart';
import '../models/event.dart';
import '../network/events.dart';
import 'shakeapp.dart';
import '../utils/app_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Event>> futureEvents;

  @override
  void initState() {
    super.initState();
    futureEvents = EventRequest.fetchEvents();
  }

  void _onEventTap(Event event) {
    if (event.eventName == 'Shake App Challenge') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShakeApp()),
      );
    } else if (event.eventName == 'Click App Challenge') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClickApp()),
      );
    }
  }

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppStyles.getGradientDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: Icon(Icons.menu, color: Colors.white),
                          onPressed: () => _openDrawer(context),
                        );
                      },
                    ),
                    Text(
                      'Danh sách sự kiện',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 48), // To balance the AppBar
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FutureBuilder<List<Event>>(
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
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(event.imageUrl),
                                  radius: 30,
                                ),
                                title: Text(
                                  event.companyName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(event.eventName),
                                    Text('Kết thúc: ${event.endTime}'),
                                  ],
                                ),
                                trailing: CircularProgressIndicator(
                                  value: 0.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFff5c30)),
                                ),
                                onTap: () => _onEventTap(event),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
