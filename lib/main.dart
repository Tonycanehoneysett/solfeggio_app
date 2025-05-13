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
      body: Column(
        children: [
          // Full-screen image
          Expanded(
            flex: 3,
            child: Image.asset(
              'assets/icon/app_icon.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          // Text + Button section
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Audio Wellness provides healing tones to support mind and body.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TonesPage()),
                    );
                  },
                  child: Text('Explore Tones'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TonesPage extends StatelessWidget {
  final List<Map<String, String>> tones = [
    {'name': '432 Hz', 'benefit': 'Calming, grounding'},
    {'name': '528 Hz', 'benefit': 'DNA healing, transformation'},
    {'name': '639 Hz', 'benefit': 'Harmony in relationships'},
    {'name': '741 Hz', 'benefit': 'Detox, cleansing'},
    {'name': '852 Hz', 'benefit': 'Spiritual awakening'},
    {'name': '963 Hz', 'benefit': 'Pineal gland, connect'},
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
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Play ${tone['name']}')),
              );
            },
          );
        },
      ),
    );
  }
}
