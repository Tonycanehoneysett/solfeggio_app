import 'package:flutter/material.dart';

class TonesPage extends StatefulWidget {
  const TonesPage({super.key});

  @override
  State<TonesPage> createState() => _TonesPageState();
}

class _TonesPageState extends State<TonesPage> {
  final List<Map<String, String>> tones = [
    {'name': '174Hz', 'benefit': 'Pain relief, stress'},
    {'name': '285Hz', 'benefit': 'Cellular repair'},
    {'name': '396Hz', 'benefit': 'Fear, guilt release'},
    {'name': '417Hz', 'benefit': 'Emotional healing'},
    {'name': '432Hz', 'benefit': 'Calming, grounding'},
    {'name': '528Hz', 'benefit': 'DNA healing, love'},
    {'name': '639Hz', 'benefit': 'Harmony in relationships'},
    {'name': '852Hz', 'benefit': 'Spiritual awakening'},
    {'name': '963Hz', 'benefit': 'Pineal gland, connection'},
  ];

  AudioPlayer? _player;
  String? _currentlyPlaying;

  Future<void> _handleToneTap(String toneName) async {
    final filename = '${toneName.toLowerCase()}_30min.mp3';
    
    // If the same tone is playing, stop it
    if (_currentlyPlaying == filename) {
      await _player?.stop();
      setState(() => _currentlyPlaying = null);
      return;
    }

    // Stop previous tone
    await _player?.stop();

    // Start new tone on loop
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
          return ListTile(
            title: Text(tone['name']!),
            subtitle: Text(tone['benefit']!),
            onTap: () => _handleToneTap(tone['name']!),
            trailing: _currentlyPlaying == '${tone['name']!.toLowerCase()}_30min.mp3'
                ? const Icon(Icons.pause_circle)
                : const Icon(Icons.play_circle),
          );
        },
      ),
    );
  }
}
