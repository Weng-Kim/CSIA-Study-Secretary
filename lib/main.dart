import 'package:flutter/material.dart';
import 'package:studysecretary_alpha/Home.dart';
import 'package:studysecretary_alpha/UserDataForm.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:studysecretary_alpha/DatabaseHelper.dart';
import 'package:studysecretary_alpha/Calendar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


void main() {
  // Initialize timezone data
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TextEditingController to capture the username and password from the input fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Function to fetch user data by username from the database
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final Database db = await DatabaseHelper().initDatabase();

    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Function to handle login logic
  Future<void> _login() async {
    // Fetching values from the TextEditingController (i.e., from the input fields)
    String inputUsername = _usernameController.text;
    String inputPassword = _passwordController.text;

    final user = await getUserByUsername(inputUsername);

    if (user != null) {
      String dbPassword = user['password'];

      if (dbPassword == inputPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid password')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Welcome to Study Secretary!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Please enter your login credentials.',
              style: TextStyle(fontSize: 18),
            ),
            // Username input field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            // Password input field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Login button that triggers the _login method
            ElevatedButton(
              onPressed: () {
                _login(); // Calling the _login method when login button is pressed
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            // Create Account button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserDataForm()),
                );
                print('Create Account button pressed');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Create Account'),
            ),
            const SizedBox(width: 20),
            // Forgot Password button
            ElevatedButton(
              onPressed: () {
                print('Forgot Password button pressed');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Forgot Password'),
            ),
          ],
        ),
      ),
    );
  }
}
