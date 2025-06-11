import 'package:flutter/material.dart';
import 'package:minimsg/core/app_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:minimsg/core/widgets/circel_profile.dart';

class EmojiPickerWidget extends StatefulWidget {
  final String selectedEmoji;
  final Function(String) onEmojiSelected;

  const EmojiPickerWidget({
    super.key,
    required this.selectedEmoji,
    required this.onEmojiSelected,
  });

  @override
  State<EmojiPickerWidget> createState() => _EmojiPickerWidgetState();
}

class _EmojiPickerWidgetState extends State<EmojiPickerWidget> {
  bool _showAll = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isOnline = true;
  final _customEmojiController = TextEditingController();
  bool _showCustomInput = false;
  final List<String> _customEmojis = [];

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _initializeEmojis();
  }

  @override
  void dispose() {
    _customEmojiController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      setState(() {
        _isOnline = connectivityResult != ConnectivityResult.none;
      });
    } catch (e) {
      setState(() {
        _isOnline = false;
        _hasError = true;
        _errorMessage = 'Failed to check internet connection';
      });
    }
  }

  Future<void> _initializeEmojis() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load emojis';
      });
    }
  }

  bool _isValidEmoji(String text) {
    // Check if the text is a single emoji
    final emojiRegex = RegExp(
      r'^[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F000}-\u{1F02F}\u{1F0A0}-\u{1F0FF}\u{1F100}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{1F1E0}-\u{1F1FF}\u{1F200}-\u{1F2FF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F780}-\u{1F7FF}\u{1F800}-\u{1F8FF}\u{1F900}-\u{1F9FF}\u{1FA00}-\u{1FA6F}\u{1FA70}-\u{1FAFF}\u{1FAB0}-\u{1FABF}\u{1FAC0}-\u{1FAFF}\u{1FAD0}-\u{1FAFF}\u{1FAE0}-\u{1FAFF}\u{1FAF0}-\u{1FAFF}\u{1FB00}-\u{1FBFF}\u{1FC00}-\u{1FCFF}\u{1FD00}-\u{1FDFF}\u{1FE00}-\u{1FEFF}\u{1FF00}-\u{1FFFF}\u{2000}-\u{206F}\u{2070}-\u{209F}\u{20A0}-\u{20CF}\u{20D0}-\u{20FF}\u{2100}-\u{214F}\u{2150}-\u{218F}\u{2190}-\u{21FF}\u{2200}-\u{22FF}\u{2300}-\u{23FF}\u{2400}-\u{243F}\u{2440}-\u{245F}\u{2460}-\u{24FF}\u{2500}-\u{257F}\u{2580}-\u{259F}\u{25A0}-\u{25FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{27C0}-\u{27EF}\u{27F0}-\u{27FF}\u{2800}-\u{28FF}\u{2900}-\u{297F}\u{2980}-\u{29FF}\u{2A00}-\u{2AFF}\u{2B00}-\u{2BFF}\u{2C00}-\u{2C5F}\u{2C60}-\u{2C7F}\u{2C80}-\u{2CFF}\u{2D00}-\u{2D2F}\u{2D30}-\u{2D7F}\u{2D80}-\u{2DDF}\u{2DE0}-\u{2DFF}\u{2E00}-\u{2E7F}\u{2E80}-\u{2EFF}\u{2F00}-\u{2FDF}\u{2FF0}-\u{2FFF}\u{3000}-\u{303F}\u{3040}-\u{309F}\u{30A0}-\u{30FF}\u{3100}-\u{312F}\u{3130}-\u{318F}\u{3190}-\u{319F}\u{31A0}-\u{31BF}\u{31C0}-\u{31EF}\u{31F0}-\u{31FF}\u{3200}-\u{32FF}\u{3300}-\u{33FF}\u{3400}-\u{4DBF}\u{4DC0}-\u{4DFF}\u{4E00}-\u{9FFF}\u{A000}-\u{A48F}\u{A490}-\u{A4CF}\u{A4D0}-\u{A4FF}\u{A500}-\u{A63F}\u{A640}-\u{A69F}\u{A6A0}-\u{A6FF}\u{A700}-\u{A71F}\u{A720}-\u{A7FF}\u{A800}-\u{A82F}\u{A830}-\u{A83F}\u{A840}-\u{A87F}\u{A880}-\u{A8DF}\u{A8E0}-\u{A8FF}\u{A900}-\u{A92F}\u{A930}-\u{A95F}\u{A960}-\u{A97F}\u{A980}-\u{A9DF}\u{A9E0}-\u{A9FF}\u{AA00}-\u{AA5F}\u{AA60}-\u{AA7F}\u{AA80}-\u{AADF}\u{AAE0}-\u{AAFF}\u{AB00}-\u{AB2F}\u{AB30}-\u{AB6F}\u{AB70}-\u{ABBF}\u{ABC0}-\u{ABFF}\u{AC00}-\u{D7AF}\u{D7B0}-\u{D7FF}\u{D800}-\u{DB7F}\u{DB80}-\u{DBFF}\u{DC00}-\u{DFFF}\u{E000}-\u{F8FF}\u{F900}-\u{FAFF}\u{FB00}-\u{FB4F}\u{FB50}-\u{FDFF}\u{FE00}-\u{FE0F}\u{FE10}-\u{FE1F}\u{FE20}-\u{FE2F}\u{FE30}-\u{FE4F}\u{FE50}-\u{FE6F}\u{FE70}-\u{FEFF}\u{FF00}-\u{FFEF}\u{FFF0}-\u{FFFF}]$',
      unicode: true,
    );
    return emojiRegex.hasMatch(text);
  }

  void _handleCustomEmoji() {
    final emoji = _customEmojiController.text.trim();
    if (emoji.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an emoji'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isValidEmoji(emoji)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid single emoji'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_customEmojis.contains(emoji)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This emoji is already added'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _customEmojis.insert(0, emoji);
      _showCustomInput = false;
      _customEmojiController.clear();
    });
    widget.onEmojiSelected(emoji);
  }

  List<String> get popularEmojis {
    return [
      // Smileys & Emotion
      '😀', '😃', '😄', '😁', '😅', '😂', '🤣', '😊',
      '😇', '🙂', '🙃', '😉', '😌', '😍', '🥰', '😘',
      '😗', '😙', '😚', '😋', '😛', '😝', '😜', '🤪',
      '🤨', '🧐', '🤓', '😎', '🤩', '🥳', '😏', '😒',
      '😞', '😔', '😟', '😕', '🙁', '☹️', '😣', '😖',
      '😫', '😩', '🥺', '😢', '😭', '😤', '😠', '😡',
      '🤬', '🤯', '😳', '🥵', '🥶', '😱', '😨', '😰',
      '😥', '😓', '🤗', '🤔', '🤭', '🤫', '🤥', '😶',
      '😐', '😑', '😬', '🙄', '😯', '😦', '😧', '😮',
      '😲', '🥱', '😴', '🤤', '😪', '😵', '🤐', '🥴',
      '🤢', '🤮', '🤧', '😷', '🤒', '🤕', '🤑', '🤠',

      // Animals & Nature
      '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
      '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔',
      '🐧', '🐦', '🐤', '🦆', '🦅', '🦉', '🦇', '🐺',
      '🐗', '🐴', '🦄', '🐝', '🐛', '🦋', '🐌', '🐞',
      '🐜', '🦗', '🕷️', '🕸️', '🦂', '🦟', '🦠', '🐢',
      '🐍', '🦎', '🦖', '🦕', '🐙', '🦑', '🦐', '🦞',
      '🦀', '🐡', '🐠', '🐟', '🐬', '🐳', '🐋', '🦈',
      '🐊', '🐅', '🐆', '🦓', '🦍', '🦧', '🐘', '🦛',
      '🦏', '🐪', '🐫', '🦒', '🦘', '🐃', '🐂', '🐄',
      '🐎', '🐖', '🐏', '🐑', '🦙', '🐐', '🦌', '🐕',

      // Food & Drink
      '🍎', '🍐', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓',
      '🍈', '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅',
      '🍆', '🥑', '🥦', '🥬', '🥒', '🌶️', '🌽', '🥕',
      '🧄', '🧅', '🥔', '🍠', '🥐', '🥯', '🍞', '🥖',
      '🥨', '🧀', '🥚', '🍳', '🧈', '🥞', '🧇', '🥓',
      '🥩', '🍗', '🍖', '🦴', '🌭', '🍔', '🍟', '🍕',
      '🥪', '🥙', '🧆', '🌮', '🌯', '🥗', '🥘', '🥫',
      '🍝', '🍜', '🍲', '🍛', '🍣', '🍱', '🥟', '🦪',
      '🍤', '🍙', '🍚', '🍘', '🍥', '🥠', '🥮', '🍢',
      '🍡', '🍧', '🍨', '🍦', '🥧', '🧁', '🍰', '🎂',

      // Activities & Objects
      '⚽️', '🏀', '🏈', '⚾️', '🥎', '🎾', '🏐', '🏉',
      '🎱', '🏓', '🏸', '🏒', '🏑', '🥍', '🏏', '🥊',
      '🥋', '🥅', '⛳️', '⛸️', '🎣', '🤿', '🎽', '🛹',
      '🛷', '⛷️', '🏂', '🏋️', '🤼', '🤸', '⛹️', '🤺',
      '🤾', '🏌️', '🏇', '🧘', '🏄', '🏊', '🤽', '🚣',
      '🧗', '🚵', '🚴', '🏆', '🥇', '🥈', '🥉', '🏅',
      '🎖️', '🏵️', '🎗️', '🎫', '🎟️', '🎪', '🤹', '🎭',
      '🎨', '🎬', '🎤', '🎧', '🎼', '🎹', '🥁', '🎷',
      '🎺', '🎸', '🎻', '🎲', '♟️', '🎯', '🎳', '🎮',
      '🎰', '🧩', '🎨', '📱', '💻', '⌨️', '🖥️', '🖨️',
    ];
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
              _initializeEmojis();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppCore.primaryColor),
        ),
      ),
    );
  }

  Widget _buildOfflineWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, color: Colors.orange, size: 48),
          const SizedBox(height: 16),
          const Text(
            'No internet connection',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _checkConnectivity,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiGrid(List<String> emojis, {bool isCustom = false}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        // mainAxisSpacing: 2,
        // crossAxisSpacing: 3,
      ),
      itemCount: emojis.length,
      itemBuilder: (context, index) {
        final emoji = emojis[index];
        final isSelected = emoji == widget.selectedEmoji;
        return GestureDetector(
          onTap: () => widget.onEmojiSelected(emoji),
          child: Center(
            child: CircleProfile(
              40,
              isSelected ? Colors.white : Colors.grey.shade800,
              emoji,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOnline) {
      return _buildOfflineWidget();
    }

    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_hasError) {
      return _buildErrorWidget();
    }

    final displayEmojis =
        _showAll ? popularEmojis : popularEmojis.sublist(0, 20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Emoji',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              if (_customEmojis.isNotEmpty) ...[
                _buildEmojiGrid(_customEmojis, isCustom: true),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
              ],
              _buildEmojiGrid(displayEmojis),
              const SizedBox(height: 16),
              if (!_showAll)
                TextButton(
                  onPressed: () => setState(() => _showAll = true),
                  child: const Text(
                    'Show More Emojis',
                    style: TextStyle(color: AppCore.primaryColor),
                  ),
                ),
              if (_showAll)
                TextButton(
                  onPressed: () => setState(() => _showAll = false),
                  child: const Text(
                    'Show Less',
                    style: TextStyle(color: AppCore.primaryColor),
                  ),
                ),
              const SizedBox(height: 8),
              if (!_showCustomInput)
                TextButton.icon(
                  onPressed: () => setState(() => _showCustomInput = true),
                  icon: const Icon(Icons.add, color: AppCore.primaryColor),
                  label: const Text(
                    'Add Custom Emoji',
                    style: TextStyle(color: AppCore.primaryColor),
                  ),
                ),
              if (_showCustomInput)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _customEmojiController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'iphone',
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter emoji',
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _handleCustomEmoji,
                        icon: const Icon(
                          Icons.check,
                          color: AppCore.primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed:
                            () => setState(() {
                              _showCustomInput = false;
                              _customEmojiController.clear();
                            }),
                        icon: const Icon(Icons.close, color: Colors.red),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
