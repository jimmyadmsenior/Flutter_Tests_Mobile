import 'package:flutter/material.dart';
import '../controllers/audio_controller.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  late AudioController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AudioController();
    _controller.addListener(_onControllerUpdate);
    _initializeAudio();
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeAudio() async {
    final error = await _controller.initializeAudio();
    if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _startRecording() async {
    final error = await _controller.startRecording();
    if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _stopRecording() async {
    final error = await _controller.stopRecording();
    if (error == null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gravação concluída!')));
    } else if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _playRecording() async {
    final error = await _controller.playRecording();
    if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _stopPlaying() async {
    final error = await _controller.stopPlaying();
    if (error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Áudio'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gravação de Áudio',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _controller.isRecording
                                  ? Colors.red
                                  : Colors.grey[300],
                              boxShadow: _controller.isRecording
                                  ? [
                                      BoxShadow(
                                        color: Colors.red.withAlpha(3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: IconButton(
                              onPressed: _controller.isRecording
                                  ? _stopRecording
                                  : _startRecording,
                              icon: Icon(
                                _controller.isRecording
                                    ? Icons.stop
                                    : Icons.mic,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_controller.isRecording) ...[
                            Text(
                              'Gravando...',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              _controller.formatDuration(
                                _controller.recordingDuration,
                              ),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'Toque para gravar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_controller.hasRecording) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reprodução',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _controller.isPlaying
                                ? _stopPlaying
                                : _playRecording,
                            icon: Icon(
                              _controller.isPlaying
                                  ? Icons.stop
                                  : Icons.play_arrow,
                            ),
                            label: Text(
                              _controller.isPlaying ? 'Parar' : 'Reproduzir',
                            ),
                          ),
                        ],
                      ),
                      if (_controller.isPlaying) ...[
                        const SizedBox(height: 12),
                        const Center(
                          child: Text(
                            'Reproduzindo áudio...',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
