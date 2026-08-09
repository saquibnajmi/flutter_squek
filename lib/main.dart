import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer player = AudioPlayer();

  Future<void> playClick() async {
    final player = AudioPlayer();
    await player.play(AssetSource('click.mp3'));
    // Optional: free resources when sound finishes
    player.onPlayerComplete.listen((_) {
      player.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: playClick,
          child: const Text(
            'BOP',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}