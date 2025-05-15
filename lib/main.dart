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
      backgroundColor: Colors.blue[900], // Royal blue
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
            const SizedBox(height: 10),
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
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[900],
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

  Future<void> _handleToneTap(String toneName) async {
    final filename = '${toneName.toLowerCase()}_30min.mp3';

    if (_currentlyPlaying == filename) {
      await _player.stop();
      setState(() => _currentlyPlaying = null);
      return;
    }

    try {
      await _player.stop();
      await _player.setLoopMode(LoopMode.one);
      await _player.setAsset('assets/audio/$filename');
      await _player.play();
      setState(() {
        _currentlyPlaying = filename;
      });
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
    appBar: AppBar(
  backgroundColor: Colors.blue[900],
  iconTheme: IconThemeData(color: Colors.white),
  title: const Text(
    'Healing Tones',
    style: TextStyle(color: Colors.white),
  ),
),
        backgroundColor: Colors.blue[900],
        title: const Text('Healing Tones'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _stopPlayback,
        child: const Icon(Icons.stop, size: 32),
      ),
      body: ListView.builder(
        itemCount: tones.length,
        itemBuilder: (context, index) {
          final tone = tones[index];
          final filename = '${tone['name']!.toLowerCase()}_30min.mp3';
          final isPlaying = _currentlyPlaying == filename;

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
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: Colors.white,
            ),
            onTap: () => _handleToneTap(tone['name']!),
          );
        },
      ),
    );
  }
}
