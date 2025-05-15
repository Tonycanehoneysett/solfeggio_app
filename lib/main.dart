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
      backgroundColor: const Color(0xFF002366), // Royal blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Audio Wellness',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select the frequency that best supports your emotional and physical needs',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
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

  final List<AudioPlayer> _players = [];
  bool isPlaying = false;

  @override
  void dispose() {
    for (var player in _players) {
      player.dispose();
    }
    super.dispose();
  }

  Future<void> _playTone(String toneName) async {
    final player = AudioPlayer();
    final filename = 'assets/audio/${toneName.toLowerCase()}_30min.mp3';
    await player.setLoopMode(LoopMode.one);
    await player.setAsset(filename);
    await player.play();
    _players.add(player);
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> _stopAllTones() async {
    for (var player in _players) {
      await player.stop();
    }
    _players.clear();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002366),
      appBar: AppBar(
        title: const Text('Healing Tones'),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tones.length,
              itemBuilder: (context, index) {
                final tone = tones[index];
                return ListTile(
                  title: Text(
                    tone['name']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    tone['benefit']!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () => _playTone(tone['name']!),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (isPlaying)
            Center(
              child: IconButton(
                iconSize: 64,
                onPressed: _stopAllTones,
                icon: const Icon(Icons.stop_circle, color: Colors.red),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
