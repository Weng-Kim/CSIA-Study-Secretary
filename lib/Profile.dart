import 'package:flutter/material.dart';
import 'package:studysecretary_alpha/DatabaseHelper.dart';
//import 'package:studysecretary_alpha/UserDataForm.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.fetchProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching profiles.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No profiles found.'));
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
      ),
    );
  }
}
