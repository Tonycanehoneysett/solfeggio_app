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
      backgroundColor: Colors.blue.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Audio\nWellness',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.lightGreenAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Frequency Healing For Mind & Body',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Select the frequency that best supports your emotional and physical needs',
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TonesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Text('Explore Tones'),
              ),
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
  final Set<String> _currentlyPlaying = {};

  Future<void> _handleToneTap(String toneName) async {
    final filename = '${toneName.toLowerCase()}_30min.mp3';

    if (_currentlyPlaying.contains(filename)) {
      await _players[filename]?.stop();
      setState(() {
        _currentlyPlaying.remove(filename);
      });
      return;
    }

    final player = AudioPlayer();
    await player.setLoopMode(LoopMode.one);
    await player.setAsset('assets/audio/$filename');
    await player.play();

    _players[filename] = player;
    setState(() {
      _currentlyPlaying.add(filename);
    });
  }

  Future<void> _stopAll() async {
    for (final player in _players.values) {
      await player.stop();
    }
    setState(() {
      _currentlyPlaying.clear();
    });
  }

  @override
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
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
                final filename = '${tone['name']!.toLowerCase()}_30min.mp3';
                final isPlaying = _currentlyPlaying.contains(filename);

                return ListTile(
                  title: Text(tone['name']!),
                  subtitle: Text(tone['benefit']!),
                  trailing: IconButton(
                    icon: Icon(isPlaying ? Icons.stop_circle : Icons.play_circle),
                    onPressed: () => _handleToneTap(tone['name']!),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.stop),
              label: const Text('Stop All'),
              onPressed: _currentlyPlaying.isNotEmpty ? _stopAll : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
