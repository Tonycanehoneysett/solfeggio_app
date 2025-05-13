import 'package:flutter/material.dart';

void main() => runApp(AudioWellnessApp());

class AudioWellnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Wellness',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Wellness')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Audio Wellness provides healing tones to support mind and body.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TonesPage()),
                );
              },
              child: Text('Explore Tones'),
            ),
          ],
        ),
      ),
    );
  }
}

class TonesPage extends StatelessWidget {
  final List<Map<String, String>> tones = [
    {'name': '396 Hz', 'benefit': 'Liberates guilt and fear'},
    {'name': '417 Hz', 'benefit': 'Facilitates change'},
    {'name': '528 Hz', 'benefit': 'Cellular regeneration'},
    {'name': '639 Hz', 'benefit': 'Heals relationships'},
    {'name': '741 Hz', 'benefit': 'Awakens intuition'},
    {'name': '852 Hz', 'benefit': 'Spiritual order'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Healing Tones')),
      body: ListView.builder(
        itemCount: tones.length,
        itemBuilder: (context, index) {
          final tone = tones[index];
          return ListTile(
            title: Text(tone['name']!),
            subtitle: Text(tone['benefit']!),
            trailing: Icon(Icons.play_arrow), // replace with audio player logic
            onTap: () {
              // handle play tone (not wired yet)
            },
          );
        },
      ),
    );
  }
}
