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
      backgroundColor: Color(0xFFE6F2FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Image (make sure the asset is correctly referenced)
              Image.asset(
                'assets/icon/app_icon.png',
                height: 160,
              ),
              const SizedBox(height: 20),
              const Text(
                'Audio Wellness',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select the frequency that best supports your emotional and physical needs',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
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
  final Map<String, AudioPlayer> _players = {};
  bool _isPlaying = false;

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

  Future<void> _playTone(String name) async {
    final filename = '${name.toLowerCase()}_30min.mp3';
    final player = AudioPlayer();
    await player.setLoopMode(LoopMode.one);
    await player.setAsset('assets/audio/$filename');
    await player.play();
    _players[name] = player;

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
      appBar: AppBar(title: const Text('Healing Tones')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tones.length,
              itemBuilder: (context, index) {
                final tone = tones[index];
                return ListTile(
                  title: Text(tone['name']!),
                  subtitle: Text(tone['benefit']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_circle_fill),
                    onPressed: () => _playTone(tone['name']!),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          if (_isPlaying)
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: _stopAllTones,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(24),
                ),
                child: const Icon(Icons.stop, size: 40, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
