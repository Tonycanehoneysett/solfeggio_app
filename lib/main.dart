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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/icon/app_icon.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.4), // optional overlay
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Audio Wellness provides healing tones to support mind and body.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 24),
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
        ],
      ),
    );
  }
}

class TonesPage extends StatelessWidget {
  final List<Map<String, String>> tones = [
    {'name': '396 Hz', 'benefit': 'Liberates fear and guilt'},
    {'name': '417 Hz', 'benefit': 'Facilitates change'},
    {'name': '528 Hz', 'benefit': 'DNA repair and healing'},
    {'name': '639 Hz', 'benefit': 'Harmonizes relationships'},
    {'name': '741 Hz', 'benefit': 'Cleanses toxins'},
    {'name': '852 Hz', 'benefit': 'Awakens intuition'},
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
          );
        },
      ),
    );
  }
}
