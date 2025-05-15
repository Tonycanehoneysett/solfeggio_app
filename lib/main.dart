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
      body: Column(
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
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
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
