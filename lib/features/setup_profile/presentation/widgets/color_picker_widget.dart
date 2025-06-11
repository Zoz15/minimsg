import 'package:flutter/material.dart';
import 'package:minimsg/core/app_core.dart';

class ColorPickerWidget extends StatefulWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  bool _showAll = false;
  bool _showColorPalette = false;

  static const List<Color> popularColors = [
    // Social Media Colors
    Color(0xFF1DA1F2), // Twitter Blue
    Color(0xFFE1306C), // Instagram Pink
    Color(0xFF25D366), // WhatsApp Green
    Color(0xFF5865F2), // Discord Blurple
    Color(0xFFFF0000), // YouTube Red
    Color(0xFF00A2FF), // Facebook Blue
    Color(0xFF0A66C2), // LinkedIn Blue
    Color(0xFF1DB954), // Spotify Green
    // Modern UI Colors
    Color(0xFF6C5CE7), // Modern Purple
    Color(0xFF00B894), // Mint Green
    Color(0xFF00CEC9), // Turquoise
    Color(0xFFFDCB6E), // Soft Yellow
    Color(0xFFE17055), // Coral
    Color(0xFFD63031), // Red
    Color(0xFF0984E3), // Blue
    Color(0xFF6C5CE7), // Purple
    // Material Design Colors
    Color(0xFF6200EE), // Primary Purple
    Color(0xFF03DAC6), // Teal
    Color(0xFF018786), // Dark Teal
    Color(0xFFBB86FC), // Light Purple
    Color(0xFFCF6679), // Error Red
    Color(0xFF121212), // Dark Background
    Color(0xFF1F1B24), // Dark Surface
    Color(0xFF3700B3), // Dark Primary
    // Gradient Colors
    Color(0xFF4158D0), // Blue Gradient
    Color(0xFFC850C0), // Pink Gradient
    Color(0xFFFFCC70), // Yellow Gradient
    Color(0xFF0093E9), // Sky Blue
    Color(0xFF80D0C7), // Mint
    Color(0xFF8EC5FC), // Light Blue
    Color(0xFFE0C3FC), // Light Purple
    Color(0xFFA9C9FF), // Pastel Blue
    // Neon Colors
    Color(0xFF00FF00), // Neon Green
    Color(0xFFFF00FF), // Neon Pink
    Color(0xFF00FFFF), // Neon Cyan
    Color(0xFFFFFF00), // Neon Yellow
    Color(0xFFFF0000), // Neon Red
    Color(0xFF0000FF), // Neon Blue
    Color(0xFFFFA500), // Neon Orange
    Color(0xFF800080), // Neon Purple
    // Pastel Colors
    Color(0xFFFFB3BA), // Pastel Pink
    Color(0xFFBAFFC9), // Pastel Green
    Color(0xFFBAE1FF), // Pastel Blue
    Color(0xFFFFFFBA), // Pastel Yellow
    Color(0xFFFFE4BA), // Pastel Orange
    Color(0xFFE4BAFF), // Pastel Purple
    Color(0xFFBAFFE4), // Pastel Mint
    Color(0xFFFFBAE4), // Pastel Rose
  ];

  @override
  Widget build(BuildContext context) {
    final displayColors =
        _showAll ? popularColors : popularColors.sublist(0, 20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Background Color',
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
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: displayColors.length,
                itemBuilder: (context, index) {
                  final color = displayColors[index];
                  final isSelected = color == widget.selectedColor;
                  return GestureDetector(
                    onTap: () => widget.onColorSelected(color),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child:
                          isSelected
                              ? const Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              )
                              : null,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              if (!_showAll)
                TextButton(
                  onPressed: () => setState(() => _showAll = true),
                  child: const Text(
                    'Show More Colors',
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
              if (!_showColorPalette)
                TextButton.icon(
                  onPressed: () => setState(() => _showColorPalette = true),
                  icon: const Icon(Icons.palette, color: AppCore.primaryColor),
                  label: const Text(
                    'Add Custom Color',
                    style: TextStyle(color: AppCore.primaryColor),
                  ),
                ),
              if (_showColorPalette)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Color Palette',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed:
                                () => setState(() => _showColorPalette = false),
                            icon: const Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                        itemCount: popularColors.length,
                        itemBuilder: (context, index) {
                          final color = popularColors[index];
                          final isSelected = color == widget.selectedColor;
                          return GestureDetector(
                            onTap: () {
                              widget.onColorSelected(color);
                              setState(() => _showColorPalette = false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child:
                                  isSelected
                                      ? const Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      )
                                      : null,
                            ),
                          );
                        },
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
