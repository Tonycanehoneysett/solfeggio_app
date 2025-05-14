import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});
final tones = [
  {'name': '174Hz', 'benefit': 'Pain relief & stress reduction'},
  {'name': '285Hz', 'benefit': 'Healing tissues & organs'},
  {'name': '396Hz', 'benefit': 'Liberating fear & guilt'},
  {'name': '417Hz', 'benefit': 'Undoing situations & trauma'},
  {'name': '432Hz', 'benefit': 'Harmonizing body & spirit'},
  {'name': '528Hz', 'benefit': 'DNA repair & transformation'},
  {'name': '639Hz', 'benefit': 'Connecting relationships'},
  {'name': '741Hz', 'benefit': 'Solving problems & intuition'},
  {'name': '852Hz', 'benefit': 'Spiritual awakening'},
  {'name': '963Hz', 'benefit': 'Divine consciousness'},
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: Colors.blue.shade800,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Audio Wellness',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Frequency Healing For Mind & Body',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Select the frequency that best supports your emotional and physical needs',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
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
            child: const Text('Explore Tones'),
          ),
        ],
      ),
    );
  }
}
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
class TonesPage extends StatefulWidget {
  const TonesPage({super.key});

  @override
  State<TonesPage> createState() => _TonesPageState();
}

class TonesPage extends StatefulWidget {
  const TonesPage({super.key});

  @override
  State<TonesPage> createState() => _TonesPageState();
}

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

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Healing Tones')),
      body: ListView.builder(
        itemCount: tones.length,
        itemBuilder: (context, index) {
          final tone = tones[index];
          final filename = '${tone['name']!.toLowerCase()}_30min.mp3';
          return ListTile(
            title: Text(tone['name']!),
            subtitle: Text(tone['benefit']!),
            onTap: () => _handleToneTap(tone['name']!),
            trailing: _currentlyPlaying == filename
                ? const Icon(Icons.pause_circle)
                : const Icon(Icons.play_circle),
          );
        },
      ),
    );
  }
}
class TonesPage extends StatelessWidget {
  const TonesPage({super.key});

  @override
  return Scaffold(
  appBar: AppBar(title: const Text('Healing Tones')),
  body: ListView.builder(
    itemCount: tones.length,
    itemBuilder: (context, index) {
      final tone = tones[index];
      final filename = '${tone['name']!.toLowerCase()}_30min.mp3';
      return ListTile(
        title: Text(tone['name']!),
        subtitle: Text(tone['benefit']!),
        onTap: () => _handleToneTap(tone['name']!),
        trailing: _currentlyPlaying == filename
            ? const Icon(Icons.pause_circle)
            : const Icon(Icons.play_circle),
      );
    },
  ),
);
}
