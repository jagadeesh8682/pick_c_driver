import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/language_selection_provider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with urban landscape
          _buildBackground(),

          // Language Selection Overlay
          _buildLanguageSelectionOverlay(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB), // Sky blue
            Color(0xFFB0E0E6), // Powder blue
          ],
        ),
      ),
      child: Stack(
        children: [
          // Clouds
          _buildClouds(),

          // City skyline
          _buildCitySkyline(),

          // Road network
          _buildRoadNetwork(),

          // Yellow truck
          _buildYellowTruck(),

          // Billboard with Pick-C branding
          _buildBillboard(),
        ],
      ),
    );
  }

  Widget _buildClouds() {
    return Positioned(
      top: 50,
      child: Row(
        children: [
          _buildCloud(80, 20),
          const SizedBox(width: 100),
          _buildCloud(60, 40),
          const SizedBox(width: 80),
          _buildCloud(70, 30),
        ],
      ),
    );
  }

  Widget _buildCloud(double width, double top) {
    return Positioned(
      top: top,
      child: Container(
        width: width,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildCitySkyline() {
    return Positioned(
      top: 200,
      left: 0,
      right: 0,
      child: Container(
        height: 150,
        child: CustomPaint(painter: CitySkylinePainter()),
      ),
    );
  }

  Widget _buildRoadNetwork() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: CustomPaint(painter: RoadNetworkPainter()),
    );
  }

  Widget _buildYellowTruck() {
    return Positioned(
      bottom: 120,
      left: 50,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // Truck body
            Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            // Wheels
            Positioned(
              bottom: 0,
              left: 10,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 10,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Headlights
            Positioned(
              top: 8,
              left: 5,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 5,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillboard() {
    return Positioned(
      top: 180,
      right: 30,
      child: Container(
        width: 120,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular logo
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_taxi,
                color: Colors.yellow,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Pick-C',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelectionOverlay() {
    return Consumer<LanguageSelectionProvider>(
      builder: (context, languageProvider, child) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Language Selection',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Language Options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        _buildLanguageOption(
                          'English',
                          languageProvider.selectedLanguage == 'en',
                          () => languageProvider.selectLanguage('en'),
                        ),
                        const SizedBox(height: 16),
                        _buildLanguageOption(
                          'Telugu',
                          languageProvider.selectedLanguage == 'te',
                          () => languageProvider.selectLanguage('te'),
                        ),
                        const SizedBox(height: 16),
                        _buildLanguageOption(
                          'Hindi',
                          languageProvider.selectedLanguage == 'hi',
                          () => languageProvider.selectLanguage('hi'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Continue Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: languageProvider.selectedLanguage.isNotEmpty
                            ? () => _handleContinue()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    String language,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          language,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    // Save language preference and navigate to login screen
    context.read<LanguageSelectionProvider>().saveLanguagePreference().then((
      _,
    ) {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
}

// Custom Painters for the background elements
class CitySkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    // Create building silhouettes
    final buildings = [
      {'x': 0, 'height': 80},
      {'x': 30, 'height': 60},
      {'x': 60, 'height': 100},
      {'x': 90, 'height': 70},
      {'x': 120, 'height': 90},
      {'x': 150, 'height': 50},
      {'x': 180, 'height': 110},
      {'x': 210, 'height': 75},
      {'x': 240, 'height': 85},
      {'x': 270, 'height': 65},
      {'x': 300, 'height': 95},
      {'x': 330, 'height': 55},
      {'x': 360, 'height': 80},
      {'x': 390, 'height': 70},
    ];

    for (final building in buildings) {
      path.lineTo(
        building['x']!.toDouble(),
        size.height - building['height']!.toDouble(),
      );
      path.lineTo(
        building['x']!.toDouble() + 25,
        size.height - building['height']!.toDouble(),
      );
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RoadNetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    // Main curved road
    final roadPath = Path();
    roadPath.moveTo(0, size.height * 0.7);
    roadPath.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.6,
      size.height * 0.6,
    );
    roadPath.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width,
      size.height * 0.8,
    );

    canvas.drawPath(roadPath, roadPaint);

    // Yellow center lines
    final linePath = Path();
    linePath.moveTo(0, size.height * 0.7);
    linePath.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.6,
      size.height * 0.6,
    );
    linePath.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width,
      size.height * 0.8,
    );

    canvas.drawPath(linePath, linePaint);

    // Overpass pillars
    final pillarPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final x = size.width * 0.2 + (i * size.width * 0.15);
      canvas.drawRect(
        Rect.fromLTWH(x, size.height * 0.3, 8, size.height * 0.4),
        pillarPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
