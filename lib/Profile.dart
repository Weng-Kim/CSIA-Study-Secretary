import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studysecretary_alpha/DatabaseHelper.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();

  FutureBuilder<List<Map<String, dynamic>>>

  (

  future: dbHelper.fetchProfile(),
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
  return Center(child: CircularProgressIndicator());
  } else if (snapshot.hasError) {
  return Center(child: Text('Error fetching profiles.'));
  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  return Center(child: Text('No profiles found.'));
  }

  final profiles = snapshot.data!;
  return ListView.builder(
  itemCount: profiles.length,
  itemBuilder: (context, index) {
  final profile = profiles[index];
  return ListTile(
  title: Text(profile['username'] ?? 'No username'),
  subtitle: Text('Course: ${profile['course'] ?? 'Unknown'}'),
  );
  },
  );
  },

  )

}