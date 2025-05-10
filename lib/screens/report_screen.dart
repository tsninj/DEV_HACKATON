import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/report_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  File? _image;
  final _descController = TextEditingController();
  bool _loading = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<Position> _getLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _submitReport() async {
    if (_image == null || _descController.text.isEmpty) return;

    setState(() => _loading = true);

    final position = await _getLocation();
    final storageRef = FirebaseStorage.instance.ref().child(
      'reports/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await storageRef.putFile(_image!);
    final imageUrl = await storageRef.getDownloadURL();

    final report = ReportModel(
      imageUrl: imageUrl,
      description: _descController.text,
      latitude: position.latitude,
      longitude: position.longitude,
      createdAt: DateTime.now(),
      userId: FirebaseAuth.instance.currentUser?.uid,
      status: 'new',
    );

    await FirebaseFirestore.instance.collection('reports').add(report.toJson());

    setState(() {
      _loading = false;
      _image = null;
      _descController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Report submitted")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://t3.ftcdn.net/jpg/07/24/59/76/360_F_724597608_pmo5BsVumFcFyHJKlASG2Y2KpkkfiYUU.jpg',
            ),
            radius: 18,
          ),
        ),
        title: const Text(
          'Report Damage',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true, // хүсвэл төвд байрлуулах
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 200),
            TextButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text('Take Photo'),
              onPressed: _pickImage,
            ),
            TextField(
              controller: _descController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _submitReport,
              child: _loading ? CircularProgressIndicator() : Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
