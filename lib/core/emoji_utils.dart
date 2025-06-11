import 'dart:math';

class EmojiUtils {
  static final List<String> _faceEmojis = [
    '😀', '😃', '😄', '😁', '😆', '😅', '😊', '😇', // Happy faces
    '🙂', '😉', '😌', '😍', '🥰', '😘', '😗', '😙', '😚', // Loving faces
    '😋', '😛', '😝', '😜', '🤪', '🤓', '😎', '🤩', // Playful faces
    '🥳', '🤗', '🤔', '🤭', '🤫', '😶', '😐', '😑', // Neutral faces
    '😮', '😲', '🥱', '😴', '🤤', '😪', '😵', '🤐', // Sleepy faces
    '🤑', '🤠', // Fun faces
  ];

  static String getRandomFaceEmoji() {
    final random = Random();
    return _faceEmojis[random.nextInt(_faceEmojis.length)];
  }
}
