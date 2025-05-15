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
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Audio',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            const Text(
              'Wellness',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.greenAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Frequency Healing For Mind & Body',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Select the frequency that best supports your emotional and physical needs',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade900,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
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
  String? _currentlyPlaying;

  Future<void> _handleToneTap(String toneName) async {
    final filename = '${toneName.toLowerCase()}_30min.mp3';

    // If the tone is already playing, do nothing
    if (_currentlyPlaying == filename) return;

    // Stop all currently playing tones
    await _stopAllPlayback();

    // Start new tone
    final player = AudioPlayer();
    await player.setLoopMode(LoopMode.one);
    await player.setAsset('assets/audio/$filename');
    await player.play();

    setState(() {
      _currentlyPlaying = filename;
      _players[filename] = player;
    });
  }

  Future<void> _stopAllPlayback() async {
    for (var player in _players.values) {
      await player.stop();
      await player.dispose();
    }
    _players.clear();
    setState(() => _currentlyPlaying = null);
  }

  @override
  void dispose() {
    _stopAllPlayback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healing Tones'),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.stop_circle, color: Colors.redAccent),
            tooltip: 'Stop All',
            iconSize: 36,
            onPressed: _stopAllPlayback,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: tones.length,
        itemBuilder: (context, index) {
          final tone = tones[index];
          final filename = '${tone['name']!.toLowerCase()}_30min.mp3';
          final isPlaying = _currentlyPlaying == filename;

          return ListTile(
            title: Text(tone['name']!),
            subtitle: Text(tone['benefit']!),
            trailing: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: isPlaying ? Colors.green : Colors.blue,
              size: 30,
            ),
            onTap: () => _handleToneTap(tone['name']!),
          );
        },
      ),
    );
  }
}
