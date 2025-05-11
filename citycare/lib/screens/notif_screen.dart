import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationItem {
  final String name;
  final String avatar;
  final String message;
  final String timeAgo;
  final bool highlight;

  NotificationItem({
    required this.name,
    required this.avatar,
    required this.message,
    required this.timeAgo,
    required this.highlight,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      name: json['name'],
      avatar: json['avatar'],
      message: json['message'],
      timeAgo: json['timeAgo'],
      highlight: json['highlight'].toString().toLowerCase() == 'true',
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/notif.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      setState(() {
        notifications = jsonData.map((item) => NotificationItem.fromJson(item)).toList();
      });
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      setState(() {
        notifications = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xffF6F6F6),
        title: const Text('Мэдэгдлүүд'),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('Мэдэгдэл алга байна'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(n.avatar),
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: '${n.name} ',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          text: n.message,
                          style: TextStyle(
                            color: n.highlight ? Colors.blue : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(n.timeAgo),
                );
              },
            ),
            bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: BottomAppBar(
            color: const Color(0xffECECEC),
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.feed_outlined, size: 35),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 35),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.edit_note_outlined, size: 35),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
