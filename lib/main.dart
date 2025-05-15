import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Royal blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.graphic_eq, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Audio Wellness',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Select the frequency that best supports your emotional and physical needs',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TonesPage()),
                );
              },
              child: const Text('Explore Tones'),
            ),
          ],
        ),
      ),
    );
  }
}

class TonesPage extends StatefulWidget {
  const TonesPage({super.key});

  @override
  State<TonesPage> createState() => _TonesPageState();
}

class _TonesPageState extends State<TonesPage> {
  final List<Map<String, String>> tones = [
    {'name': '174Hz', 'benefit': 'Pain relief & stress reduction'},
    {'name': '285Hz', 'benefit': 'Healing tissues & organs'},
    {'name': '396Hz', 'benefit': 'Liberating fear & guilt'},
    {'name': '417Hz', 'benefit': 'Undoing situations & trauma'},
    {'name': '528Hz', 'benefit': 'Harmonizing body & spirit'},
    {'name': '639Hz', 'benefit': 'DNA repair & transformation'},
    {'name': '741Hz', 'benefit': 'Connecting relationships'},
    {'name': '852Hz', 'benefit': 'Solving problems & intuition'},
    {'name': '963Hz', 'benefit': 'Spiritual awakening & divine consciousness'},
  ];

  final Map<String, AudioPlayer> _players = {};
  bool _isPlaying = false;

  Future<void> _playTone(String toneName) async {
    final filename = '${toneName.toLowerCase()}_30min.mp3';
    final player = AudioPlayer();
    await player.setLoopMode(LoopMode.one);
    await player.setAsset('assets/audio/$filename');
    await player.play();
    _players[toneName] = player;
    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _stopAllTones() async {
    for (var player in _players.values) {
      await player.stop();
      await player.dispose();
    }
    _players.clear();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    _stopAllTones();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Royal blue
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text('Healing Tones', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tones.length,
              itemBuilder: (context, index) {
                final tone = tones[index];
                return ListTile(
                  title: Text(tone['name']!, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(tone['benefit']!, style: const TextStyle(color: Colors.white70)),
                  onTap: () => _playTone(tone['name']!),
                  trailing: const Icon(Icons.play_circle, color: Colors.white),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          if (_isPlaying)
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ElevatedButton(
                onPressed: _stopAllTones,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(24),
                ),
                child: const Icon(Icons.stop, color: Colors.white, size: 32),
              ),
            ),
        ],
      ),
    );
  }
}
