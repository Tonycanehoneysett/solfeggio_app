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
      backgroundColor: const Color(0xFF003366), // Royal Blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Audio Wellness',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select the frequency that best supports your\nemotional and physical needs',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TonesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Explore Tones'),
            )
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
  final AudioPlayer _player = AudioPlayer();
  String? _currentlyPlaying;

  final List<Map<String, String>> tones = [
    {'name': '174hz_30min', 'benefit': 'Pain relief & stress reduction', 'chakra': 'Root Chakra'},
    {'name': '285hz_30min', 'benefit': 'Healing tissues & organs', 'chakra': 'Sacral Chakra'},
    {'name': '396hz_30min', 'benefit': 'Liberating fear & guilt', 'chakra': 'Solar Plexus Chakra'},
    {'name': '417hz_30min', 'benefit': 'Undoing situations & trauma', 'chakra': 'Heart Chakra'},
    {'name': '528hz_30min', 'benefit': 'Harmonizing body & spirit', 'chakra': 'Throat Chakra'},
    {'name': '639hz_30min', 'benefit': 'DNA repair & transformation', 'chakra': 'Third Eye Chakra'},
    {'name': '741hz_30min', 'benefit': 'Connecting relationships', 'chakra': 'Crown Chakra'},
    {'name': '852hz_30min', 'benefit': 'Solving problems & intuition', 'chakra': 'Soul Star Chakra'},
    {'name': '963hz_30min', 'benefit': 'Spiritual awakening & divine consciousness', 'chakra': 'Universal Chakra'},
  ];

  Future<void> _handleToneTap(String filename) async {
    try {
      await _player.stop();
      await _player.setLoopMode(LoopMode.one);
      await _player.setAsset('assets/audio/$filename.mp3');
      await _player.play();
      setState(() => _currentlyPlaying = filename);
    } catch (e) {
      debugPrint('Playback error: $e');
    }
  }

  Future<void> _stopPlayback() async {
    await _player.stop();
    setState(() => _currentlyPlaying = null);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366), // Royal Blue
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Pure Healing Tones',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: tones.length,
            itemBuilder: (context, index) {
              final tone = tones[index];
              final filename = tone['name']!;
              final isPlaying = _currentlyPlaying == filename;

              return ListTile(
                title: Text(
                  '${tone['name']!.replaceAll('_30min', '')} — ${tone['chakra']}',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  tone['benefit']!,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.stop_circle : Icons.play_circle_fill,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      _stopPlayback();
                    } else {
                      _handleToneTap(filename);
                    }
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _stopPlayback,
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
