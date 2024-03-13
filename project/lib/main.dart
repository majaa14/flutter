import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divelit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TimePercentageCalculator(),
    );
  }
}

class TimePercentageCalculator extends StatefulWidget {
  @override
  _TimePercentageCalculatorState createState() => _TimePercentageCalculatorState();
}

class _TimePercentageCalculatorState extends State<TimePercentageCalculator> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(minutes: 1));
  DateTime _currentDate = DateTime.now();

  double calculatePercentage() {
    Duration totalDuration = _endDate.difference(_startDate);
    Duration elapsedDuration = _currentDate.difference(_startDate);
    return (elapsedDuration.inMilliseconds / totalDuration.inMilliseconds) * 100;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime ?pickedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay ?pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_currentDate),
      );
      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
        setState(() {
          if (pickedDateTime.isBefore(DateTime.now())) {
            _endDate = DateTime.now();
            _startDate = pickedDateTime;
          } else {
            _endDate = pickedDateTime;
          }
          _currentDate = _startDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Divelit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Zvolte datum:',
                  style: TextStyle(fontSize: 16),
                  )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  alignment: Alignment.center,
                  icon: Icon(Icons.calendar_today),
                  iconSize: 30,
                  onPressed: () {
                    _selectDateTime(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text(
                  'Aktuální datum: ${DateFormat('dd.MM.yyyy HH:mm:ss').format(_currentDate)}',
                  style: TextStyle(fontSize: 22),
                ),
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Text(
                  'Počáteční datum: ${DateFormat('dd.MM.yyyy HH:mm:ss').format(_startDate)}',
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Text(
                  'Konečné datum: ${DateFormat('dd.MM.yyyy HH:mm:ss').format(_endDate)}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Slider(
              value: _currentDate.millisecondsSinceEpoch.toDouble(),
              min: _startDate.millisecondsSinceEpoch.toDouble(),
              max: _endDate.millisecondsSinceEpoch.toDouble(),
              onChanged: (value) {
                setState(() {
                  _currentDate = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                });
              },
            ),
            SizedBox(height: 10),
            Text(
              'Procentuální uběhlý čas: ${calculatePercentage().toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
