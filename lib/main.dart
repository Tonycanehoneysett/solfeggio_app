import "package:flutter/material.dart";
import "package:just_audio/just_audio.dart" as ja;
import "package:audio_service/audio_service.dart";

// --- Audio Handler --- 
late AudioPlayerHandler _audioHandler;

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final ja.AudioPlayer _player = ja.AudioPlayer();
  SolfeggioFrequency? _currentSolfeggioFrequency;

  AudioPlayerHandler() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    _player.processingStateStream.listen((state) {
      if (state == ja.ProcessingState.completed) {
        if (_player.loopMode != ja.LoopMode.one) {
          stop(); 
          mediaItem.add(null); 
        }
      }
    });
  }

  PlaybackState _transformEvent(ja.PlaybackEvent event) {
    // The duration of the currently playing item is typically part of the MediaItem.
    // PlaybackState itself focuses on the dynamic state of playback.
    return PlaybackState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
      },
      androidCompactActionIndices: const [0], 
      processingState: const {
        ja.ProcessingState.idle: AudioProcessingState.idle,
        ja.ProcessingState.loading: AudioProcessingState.loading,
        ja.ProcessingState.buffering: AudioProcessingState.buffering,
        ja.ProcessingState.ready: AudioProcessingState.ready,
        ja.ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
      // duration: _player.duration ?? Duration.zero, // Removed: duration is part of MediaItem
    );
  }

  Future<void> playSolfeggio(SolfeggioFrequency frequency) async {
    _currentSolfeggioFrequency = frequency;
    mediaItem.add(
      MediaItem(
        id: frequency.audioAssetPath, 
        album: "Solfeggio Harmonics", 
        title: "${frequency.hz} - ${frequency.name}",
        artist: "Mind Harmony App", 
        duration: _player.duration, // Set duration on MediaItem as well
        // artUri: Uri.parse("asset:///assets/images/app_icon.png"), // Placeholder
      )
    );
    try {
      // Ensure duration is loaded before playing if possible, or handle it if it loads later
      await _player.setAsset(frequency.audioAssetPath);
      await _player.setLoopMode(ja.LoopMode.one); // Enable looping by default
      // Duration might become available after setAsset or during/after play
      // Update MediaItem if duration changes after initial load
      _player.durationStream.firstWhere((d) => d != null).then((loadedDuration) {
        if (mediaItem.value?.id == frequency.audioAssetPath) { // Check if still the same item
            mediaItem.add(mediaItem.value!.copyWith(duration: loadedDuration));
        }
      }).catchError((_) {/* Ignore if stream closes or no duration found */});

      await _player.play();
    } catch (e) {
      // debugPrint("Error playing from AudioPlayerHandler: $e"); 
      playbackState.add(playbackState.value.copyWith(processingState: AudioProcessingState.error));
    }
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    await _player.stop();
    _currentSolfeggioFrequency = null;
    mediaItem.add(null); 
    playbackState.add(playbackState.value.copyWith(playing: false, processingState: AudioProcessingState.idle));
  }
  
  Future<void> setLoopMode(bool isLooping) async {
    await _player.setLoopMode(isLooping ? ja.LoopMode.one : ja.LoopMode.off);
  }

  bool get isLooping => _player.loopMode == ja.LoopMode.one;
  
  Stream<SolfeggioFrequency?> get currentFrequencyStream => 
      mediaItem.map((item) => item == null ? null : _currentSolfeggioFrequency);

  SolfeggioFrequency? get currentSolfeggioFrequency => _currentSolfeggioFrequency;

  void disposeHandler() async { 
    await _player.dispose();
  }
}

// --- Main App --- 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: "com.manus.solfeggio_app.channel.audio",
      androidNotificationChannelName: "Solfeggio Playback",
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  runApp(const SolfeggioApp());
}

class SolfeggioFrequency {
  final String hz;
  final String name;
  final String description;
  final String audioAssetPath;

  SolfeggioFrequency({
    required this.hz,
    required this.name,
    required this.description,
    required this.audioAssetPath,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SolfeggioFrequency &&
          runtimeType == other.runtimeType &&
          hz == other.hz &&
          name == other.name;

  @override
  int get hashCode => hz.hashCode ^ name.hashCode;
}

class SolfeggioApp extends StatelessWidget {
  const SolfeggioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Solfeggio Harmonics",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(secondary: Colors.amberAccent),
      ),
      home: const MainPlaybackScreen(),
    );
  }
}

class MainPlaybackScreen extends StatefulWidget {
  const MainPlaybackScreen({super.key});

  @override
  State<MainPlaybackScreen> createState() => _MainPlaybackScreenState();
}

class _MainPlaybackScreenState extends State<MainPlaybackScreen> {
  String _currentlyPlayingStatusText = "No track playing";

  final List<SolfeggioFrequency> _frequencies = [
    SolfeggioFrequency(hz: "174 Hz", name: "Relief & Security", description: "Alleviates pain and stress, improves concentration.", audioAssetPath: "assets/audio/174hz.mp3"),
    SolfeggioFrequency(hz: "285 Hz", name: "Healing & Restoration", description: "Heals and restores tissue, supports immune system.", audioAssetPath: "assets/audio/285hz.mp3"),
    SolfeggioFrequency(hz: "396 Hz", name: "Liberate Fear & Guilt", description: "Eliminates guilt, fears, and negative beliefs.", audioAssetPath: "assets/audio/396hz.mp3"),
    SolfeggioFrequency(hz: "417 Hz", name: "Facilitate Change", description: "Clears negative energy, aids trauma healing.", audioAssetPath: "assets/audio/417hz.mp3"),
    SolfeggioFrequency(hz: "528 Hz", name: "Love & Miracles", description: "The love frequency, transformation and miracles.", audioAssetPath: "assets/audio/528hz.mp3"),
    SolfeggioFrequency(hz: "639 Hz", name: "Harmonious Relations", description: "Fosters harmonious relationships and communication.", audioAssetPath: "assets/audio/639hz.mp3"),
    SolfeggioFrequency(hz: "741 Hz", name: "Intuition & Expression", description: "Stimulates creativity, self-expression, and intuition.", audioAssetPath: "assets/audio/741hz.mp3"),
    SolfeggioFrequency(hz: "852 Hz", name: "Spiritual Order", description: "Replaces negative thoughts, awakens inner strength.", audioAssetPath: "assets/audio/852hz.mp3"),
    SolfeggioFrequency(hz: "963 Hz", name: "Pineal Gland Activation", description: "Activates pineal gland, raises consciousness.", audioAssetPath: "assets/audio/963hz.mp3"),
    SolfeggioFrequency(hz: "User Mix 1", name: "Focus Mix Alpha", description: "User provided combination for focus.", audioAssetPath: "assets/audio/user_mix_1.mp3"),
  ];

  @override
  void initState() {
    super.initState();
    _audioHandler.playbackState.listen((playbackState) {
      if (mounted) {
        final isPlaying = playbackState.playing;
        final processingState = playbackState.processingState;
        final currentMediaItem = _audioHandler.mediaItem.value; 

        if (currentMediaItem != null) {
            SolfeggioFrequency? playingFrequency;
            try {
                playingFrequency = _frequencies.firstWhere((f) => f.audioAssetPath == currentMediaItem.id);
            } catch (e) { /* not found */ }

            if (playingFrequency != null) {
                if (isPlaying) {
                    _currentlyPlayingStatusText = "Playing: ${playingFrequency.hz} - ${playingFrequency.name}";
                } else if (processingState == AudioProcessingState.completed && !_audioHandler.isLooping) {
                    _currentlyPlayingStatusText = "Track finished";
                } else if (processingState != AudioProcessingState.idle) { 
                    _currentlyPlayingStatusText = "Paused: ${playingFrequency.hz} - ${playingFrequency.name}";
                } else {
                    _currentlyPlayingStatusText = "No track playing";
                }
            } else {
                 _currentlyPlayingStatusText = "No track playing"; 
            }
        } else {
            _currentlyPlayingStatusText = "No track playing";
        }
        if (mounted) setState(() {}); 
      }
    });
  }

  Future<void> _handlePlayRequest(SolfeggioFrequency frequency) async {
    try {
      await _audioHandler.playSolfeggio(frequency);
    } catch (e) {
      // debugPrint("Error in UI calling playSolfeggio: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error playing ${frequency.name}.")),
        );
      }
    }
  }

  Future<void> _handleTogglePlayPause() async {
    final isPlaying = _audioHandler.playbackState.value.playing;
    if (isPlaying) {
      await _audioHandler.pause();
    } else {
      if (_audioHandler.mediaItem.value == null && _frequencies.isNotEmpty) {
         if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a frequency first.")),
            );
         }
         return;
      } else if (_audioHandler.mediaItem.value != null) {
          await _audioHandler.play();
      } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select a frequency to play.")),
            );
          }
      }
    }
  }

  Future<void> _handleStop() async {
    await _audioHandler.stop();
  }

  void _handleToggleLoop() async {
    final newLoopMode = !_audioHandler.isLooping;
    await _audioHandler.setLoopMode(newLoopMode);
    if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(newLoopMode ? "Looping enabled" : "Looping disabled")),
        );
    }
    if (mounted) setState(() {}); 
  }

 @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: _audioHandler.mediaItem,
      builder: (context, mediaItemSnapshot) {
        final currentPlayingFreqPath = mediaItemSnapshot.data?.id;
        SolfeggioFrequency? currentDisplayFreq;
        if (currentPlayingFreqPath != null) {
          try {
            currentDisplayFreq = _frequencies.firstWhere((f) => f.audioAssetPath == currentPlayingFreqPath);
          } catch (e) { /* not found, keep null */ }
        }

        return StreamBuilder<PlaybackState>(
          stream: _audioHandler.playbackState,
          builder: (context, playbackStateSnapshot) {
            final playbackState = playbackStateSnapshot.data;
            final isPlaying = playbackState?.playing ?? false;
            final isLooping = _audioHandler.isLooping; 

            return Scaffold(
              appBar: AppBar(
                title: const Text("Solfeggio Harmonics"),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _frequencies.length,
                      itemBuilder: (context, index) {
                        final frequency = _frequencies[index];
                        final bool isCurrentlyPlayingThis = currentDisplayFreq == frequency && isPlaying;
                        final bool isSelected = currentDisplayFreq == frequency;

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: isCurrentlyPlayingThis ? 4 : 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: isCurrentlyPlayingThis ? Theme.of(context).colorScheme.secondary : Colors.transparent, width: 2)
                          ),
                          child: ListTile(
                            title: Text("${frequency.hz} - ${frequency.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(frequency.description),
                            leading: Icon(
                                isCurrentlyPlayingThis ? Icons.volume_up : (isSelected ? Icons.music_note_outlined : Icons.music_note),
                                color: isCurrentlyPlayingThis ? Theme.of(context).colorScheme.secondary : (isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[600]),
                                size: 40,
                            ),
                            onTap: () => _handlePlayRequest(frequency),
                            selected: isSelected,
                            selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_currentlyPlayingStatusText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(isLooping ? Icons.repeat_one_on_outlined : Icons.repeat_outlined),
                              iconSize: 30,
                              color: isLooping ? Theme.of(context).colorScheme.secondary : Colors.grey[700],
                              onPressed: _handleToggleLoop,
                              tooltip: "Toggle Loop",
                            ),
                            IconButton(
                              icon: Icon(isPlaying ? Icons.pause_circle_filled_outlined : Icons.play_circle_fill_outlined),
                              iconSize: 60,
                              onPressed: _handleTogglePlayPause,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            IconButton(
                              icon: Icon(Icons.stop_circle_outlined),
                              iconSize: 30,
                              color: Colors.grey[700],
                              onPressed: _handleStop,
                              tooltip: "Stop",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }

  @override
  void dispose() {
    _audioHandler.disposeHandler(); 
    super.dispose();
  }
}

