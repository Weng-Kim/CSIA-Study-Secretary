import 'package:flutter/material.dart';
import 'package:studysecretary_alpha/PomodoroTimer.dart';
import 'package:studysecretary_alpha/UserDataForm.dart';
import 'package:studysecretary_alpha/ExamScheduleScreen.dart';
import 'package:studysecretary_alpha/Calendar.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        leading: Builder(
          builder: (context) {
            return IconButton(
            icon: Icon(Icons.menu),
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
            DrawerHeader(
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
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserDataForm(),
                  ),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle navigation or action
                Navigator.pop(context);
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
                  MaterialPageRoute(builder: (context) => PomodoroTimer()),
                );
              },
              child: Text('Study Now.'),
            ),
            const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Calendar()),
            );
          },
          child: Text('Calendar'),
          ),
          const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
             Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExamScheduleScreen()),
             );
          },
          child: Text('See your Subjects'),
          ),
          const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}