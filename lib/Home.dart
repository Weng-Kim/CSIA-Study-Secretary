import 'package:flutter/material.dart';
import 'package:studysecretary_alpha/PomodoroTimer.dart';
import 'package:studysecretary_alpha/ExamScheduleScreen.dart';
import 'package:studysecretary_alpha/Calendar.dart';
import 'package:studysecretary_alpha/Profile.dart';

import 'Settings.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        //Mainpage
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Study Secretary!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PomodoroTimer()),
                );
              },
              child: const Text('Study Now.'),
            ),
            const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Calendar()),
            );
          },
          child: const Text('Calendar'),
          ),
          const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExamScheduleScreen()),
             );
          },
          child: const Text('See your Subjects'),
          ),
          const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}