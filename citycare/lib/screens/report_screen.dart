import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../widgets/report_card.dart';
import '../app.dart';
import '../screens/info_screen.dart';
import '../models/info_model.dart';
import '../models/user_model1.dart';
import '../screens/notif_screen.dart';
import '../widgets/information_view.dart';

class VolunteerCardScreen extends StatefulWidget {
  const VolunteerCardScreen({super.key});

  @override
  State<VolunteerCardScreen> createState() => _VolunteerCardScreenState();
}

class _VolunteerCardScreenState extends State<VolunteerCardScreen> {
  late Future<List<Volunteer>> volunteers;
  late List<InfoModel> filteredData; // Define filteredData as a list of InfoModel

  UserProfile? user;

  Future<List<Volunteer>> loadVolunteers() async {
    final data = await rootBundle.loadString('assets/volunteer.json');
    final List<dynamic> jsonData = json.decode(data);
    return jsonData.map((v) => Volunteer.fromJson(v)).toList();
  }
  Future<void> loadUser() async {
  final data = await rootBundle.loadString('assets/users.json');
  final jsonData = json.decode(data);
  setState(() {
    user = UserProfile.fromJson(jsonData);
  });
}

Future<void> loadFilteredData() async {
    final data = await rootBundle.loadString('assets/info.json');
    final List<dynamic> jsonData = json.decode(data);
    setState(() {
      filteredData = jsonData.map((v) => InfoModel.fromJson(v)).toList(); // Make sure InfoModel is defined
    });
  }

  @override
  void initState() {
    super.initState();
    volunteers = loadVolunteers();
      loadUser(); // user info load
    loadFilteredData(); // load filtered data

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: const Color(0xFFF6F6F6),
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user!.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(user!.email, style: const TextStyle(color: Colors.grey)),
                          ]),
                      CircleAvatar(backgroundImage: AssetImage(user!.avatar), radius: 30),
                    ],
                  ),
                  const SizedBox(height: 30),
                  drawerItem(Icons.settings, 'Хувийн мэдээлэл'),
                  drawerItem(Icons.note, 'Миний зарууд'),
                  drawerItem(Icons.lock, 'Нууц үг'),
                  drawerItem(Icons.brightness_4, 'Өнгө солих'),
                  drawerItem(Icons.mic, 'Текст унших'),
                  const SizedBox(height: 30),
                  drawerItem(Icons.logout, 'Гарах', color: Colors.red),
                ],
              ),
      ),
appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VolunteerCardScreen()),
            );                
          },
          child: Image.asset(
            'assets/logo.png',
            height: 70,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 35, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage(user?.avatar ?? 'assets/default_avatar.png'),
                  radius: 18,
                ),
              ),
            ),
          ),
        ],
      ), 
      body: Container(
        color: const Color(0xFFF6F6F6),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // Add scroll here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Шуурхай мэдээ', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 5),
              FutureBuilder<List<Volunteer>>(
                future: volunteers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No volunteer data.'));
                  } else {
                    final volunteerList = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: volunteerList.map((v) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: VolunteerCard(
                              name: v.name,
                              photoProvider: AssetImage(v.photo),
                              description: v.description,
                              icon: v.iconData,
                              date: v.date,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              Text('Сайн дурын ажлууд', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 5),
              FutureBuilder<List<Volunteer>>(
                future: volunteers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No volunteer data.'));
                  } else {
                    final volunteerList = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: volunteerList.map((v) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: VolunteerCard(
                              name: v.name,
                              photoProvider: AssetImage(v.photo),
                              description: v.description,
                              icon: v.iconData,
                              date: v.date,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              Text('Иргэдийн оролцоо', style: Theme.of(context).textTheme.titleLarge),
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: List.generate(
                  filteredData.length,
                  (index) => InfoCard(data: filteredData[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget drawerItem(IconData icon, String text, {Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color, fontSize: 16)),
      onTap: () {},
    );
  }
}
