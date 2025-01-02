import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:studysecretary_alpha/DatabaseHelper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class Calendar extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<Calendar> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};
  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadExamDates();
  }

  void _initializeNotifications() {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(String title, String body, DateTime scheduledTime) async {
    const androidDetails = AndroidNotificationDetails(
      'study_reminder',
      'Study Reminders',
      channelDescription: 'Reminders for study and exams',
      importance: Importance.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    // Convert `DateTime` to `TZDateTime`
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      0, // Notification ID
      title,
      body,
      tzScheduledTime,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _loadExamDates() async {
    final exams = await dbHelper.fetchAllExams();
    Map<DateTime, List<String>> events = {};

    for (var exam in exams) {
      DateTime examDate = DateTime.parse(exam['examDate']);
      String examName = exam['name'] ?? exam['examTypeName'];
      if (events[examDate] == null) {
        events[examDate] = [];
      }
      events[examDate]!.add(examName);
    }

    setState(() {
      _events = events;
    });
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _addStudyReminder(DateTime day) async {
    final reminderTime = day.subtract(Duration(hours: 1));
    await _scheduleNotification(
      "Study Reminder",
      "Prepare for exams scheduled on ${day.toLocal()}",
      reminderTime,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder set for ${day.toLocal()}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonDecoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (_selectedDay != null)
                  ..._getEventsForDay(_selectedDay!).map((event) => ListTile(
                    title: Text(event),
                    subtitle: Text('Exam Date: ${_selectedDay!.toLocal()}'),
                    trailing: IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () => _addStudyReminder(_selectedDay!),
                    ),
                  )),
                if (_selectedDay == null || _getEventsForDay(_selectedDay!).isEmpty)
                  Center(child: Text('No events for the selected day')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
