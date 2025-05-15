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
      backgroundColor: const Color(0xFF0033A0),
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
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
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
  AudioPlayer? _player;
  String? _currentlyPlaying;

  final List<Map<String, String>> tones = [
    {'name': '174Hz', 'benefit': 'Pain relief & stress reduction', 'chakra': 'Root Chakra'},
    {'name': '285Hz', 'benefit': 'Healing tissues & organs', 'chakra': 'Sacral Chakra'},
    {'name': '396Hz', 'benefit': 'Liberating fear & guilt', 'chakra': 'Solar Plexus Chakra'},
    {'name': '417Hz', 'benefit': 'Undoing situations & trauma', 'chakra': 'Heart Chakra'},
    {'name': '528Hz', 'benefit': 'Harmonizing body & spirit', 'chakra': 'Throat Chakra'},
    {'name': '639Hz', 'benefit': 'DNA repair & transformation', 'chakra': 'Third Eye Chakra'},
    {'name': '741Hz', 'benefit': 'Connecting relationships', 'chakra': 'Crown Chakra'},
    {'name': '852Hz', 'benefit': 'Solving problems & intuition', 'chakra': 'Pineal Gland'},
    {'name': '963Hz', 'benefit': 'Spiritual awakening & divine consciousness', 'chakra': 'Higher Self'},
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
      backgroundColor: const Color(0xFF0033A0),
      appBar: AppBar(
        title: const Text('Healing Tones', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0033A0),
        iconTheme: const IconThemeData(color: Colors.white),
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
                    '${tone['name']} - ${tone['chakra']}',
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
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              onPressed: _stopPlayback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
              ),
              child: const Icon(Icons.stop, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
