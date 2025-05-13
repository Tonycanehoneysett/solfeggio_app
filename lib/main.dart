import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
      backgroundColor: Colors.blue[800],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Audio Wellness',
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Select the frequency that best supports your emotional and physical needs',
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TonesPage()),
              ),
              child: Text('Explore Tones'),
            ),
          ],
        ),
      ),
    );
  }
}

class TonesPage extends StatefulWidget {
  @override
  _TonesPageState createState() => _TonesPageState();
}

class _TonesPageState extends State<TonesPage> {
  final List<Map<String, String>> tones = [
    {'name': '174 Hz', 'file': '174Hz_30min.mp3', 'benefit': 'Pain relief, grounding'},
    {'name': '285 Hz', 'file': '285Hz_30min.mp3', 'benefit': 'Tissue healing, rejuvenation'},
    {'name': '396 Hz', 'file': '396Hz_30min.mp3', 'benefit': 'Liberation from fear'},
    {'name': '417 Hz', 'file': '417Hz_30min.mp3', 'benefit': 'DNA healing, change'},
    {'name': '432 Hz', 'file': '432Hz_30min.mp3', 'benefit': 'Harmony and balance'},
    {'name': '528 Hz', 'file': '528Hz_30min.mp3', 'benefit': 'DNA repair, transformation'},
    {'name': '639 Hz', 'file': '639Hz_30min.mp3', 'benefit': 'Connection and relationships'},
    {'name': '852 Hz', 'file': '852Hz_30min.mp3', 'benefit': 'Spiritual awakening'},
    {'name': '963 Hz', 'file': '963Hz_30min.mp3', 'benefit': 'Pineal gland, higher self'},
  ];

  AudioPlayer? _player;
  String? _currentlyPlaying;

  void _handleTap(String filename) async {
    if (_currentlyPlaying == filename) {
      await _player?.stop();
      setState(() => _currentlyPlaying = null);
    } else {
      await _player?.stop();
      final newPlayer = AudioPlayer();
      await newPlayer.setReleaseMode(ReleaseMode.loop);
      await newPlayer.play(AssetSource('audio/$filename'));
      setState(() {
        _player = newPlayer;
        _currentlyPlaying = filename;
      });
    }
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

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
            trailing: _currentlyPlaying == tone['file'] ? Icon(Icons.stop) : Icon(Icons.play_arrow),
            onTap: () => _handleTap(tone['file']!),
          );
        },
      ),
    );
  }
}
