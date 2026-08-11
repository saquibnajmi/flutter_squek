import 'package:audioplayers/audioplayers.dart';

class AudioService {
  Future<void> playClick() async {
    try {
      final player = AudioPlayer();
      await player.play(AssetSource('click.mp3'));
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (_) {
      // Ignore audio playback errors so the app stays responsive.
    }
  }
}
