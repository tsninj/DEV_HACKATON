import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({Key? key}) : super(key: key);

  Future<void> _joinEvent(String eventId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final docRef = FirebaseFirestore.instance.collection('volunteer_events').doc(eventId);
    await docRef.update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Volunteer Opportunities')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('volunteer_events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final events = snapshot.data!.docs;

          if (events.isEmpty) {
            return Center(child: Text('No volunteer events yet.'));
          }

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final data = events[index].data() as Map<String, dynamic>;
              final title = data['title'] ?? 'Untitled';
              final desc = data['description'] ?? '';
              final participants = List<String>.from(data['participants'] ?? []);

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(desc),
                  trailing: ElevatedButton(
                    onPressed: () => _joinEvent(events[index].id),
                    child: Text('Join'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}