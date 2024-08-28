class Event {
  final String imageUrl;
  final String companyName;
  final String eventName;
  final String endTime;

  Event({
    required this.imageUrl,
    required this.companyName,
    required this.eventName,
    required this.endTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      imageUrl: json['imageUrl'],
      companyName: json['companyName'],
      eventName: json['eventName'],
      endTime: json['endTime'],
    );
  }
}