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
      backgroundColor: const Color(0xFF003366), // Royal blue
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
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF003366),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TonesPage()),
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
  final AudioPlayer _player = AudioPlayer();
  String? _currentlyPlaying;

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

  Future<void> _playTone(String toneName) async {
    final filename = '${toneName.toLowerCase()}_30min.mp3';
    if (_currentlyPlaying == filename) return;

    await _player.stop();
    await _player.setLoopMode(LoopMode.one);
    await _player.setAsset('assets/audio/$filename');
    await _player.play();

    setState(() {
      _currentlyPlaying = filename;
    });
  }

  void _stopPlayback() async {
    await _player.stop();
    setState(() {
      _currentlyPlaying = null;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      appBar: AppBar(
        title: const Text('Healing Tones'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
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
                  trailing: Icon(
                    _currentlyPlaying == filename
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: Colors.white,
                  ),
                  onTap: () => _playTone(tone['name']!),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: _stopPlayback,
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.stop,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
