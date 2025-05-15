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
            const Text(
              'Audio Wellness',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Frequency Healing For Mind & Body',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Select the frequency that best supports your emotional and physical needs',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
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
  AudioPlayer? _player;
  String? _currentlyPlaying;

  final List<Map<String, String>> tones = [
    {'name': '174Hz', 'benefit': 'Root Chakra — Pain relief & stress reduction'},
    {'name': '285Hz', 'benefit': 'Sacral Chakra — Healing tissues & organs'},
    {'name': '396Hz', 'benefit': 'Solar Plexus Chakra — Liberating fear & guilt'},
    {'name': '417Hz', 'benefit': 'Heart Chakra — Undoing situations & trauma'},
    {'name': '528Hz', 'benefit': 'Throat Chakra — Harmonizing body & spirit'},
    {'name': '639Hz', 'benefit': 'Third Eye Chakra — DNA repair & transformation'},
    {'name': '741Hz', 'benefit': 'Crown Chakra — Connecting relationships'},
    {'name': '852Hz', 'benefit': 'Soul Star Chakra — Solving problems & intuition'},
    {'name': '963Hz', 'benefit': 'Divine Chakra — Spiritual awakening & consciousness'},
  ];

  Future<void> _handleToneTap(String toneName) async {
    final filename = '${toneName.toLowerCase()}_30min.mp3';

    if (_currentlyPlaying == filename) {
      await _player?.stop();
      setState(() => _currentlyPlaying = null);
      return;
    }

    _player?.dispose();
    final newPlayer = AudioPlayer();
    await newPlayer.setLoopMode(LoopMode.one);
    await newPlayer.setAsset('assets/audio/$filename');
    await newPlayer.play();

    setState(() {
      _player = newPlayer;
      _currentlyPlaying = filename;
    });
  }

  void _stopPlayback() {
    _player?.stop();
    setState(() {
      _currentlyPlaying = null;
    });
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Royal blue
      appBar: AppBar(
        title: const Text('Healing Tones'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tones.length,
              itemBuilder: (context, index) {
                final tone = tones[index];
                final filename = '${tone['name']!.toLowerCase()}_30min.mp3';
                return ListTile(
                  title: Text(
                    tone['name']!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    tone['benefit']!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () => _handleToneTap(tone['name']!),
                  trailing: _currentlyPlaying == filename
                      ? const Icon(Icons.pause_circle, color: Colors.white)
                      : const Icon(Icons.play_circle, color: Colors.white),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _stopPlayback,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
            ),
            child: const Icon(Icons.stop, color: Colors.white, size: 36),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
