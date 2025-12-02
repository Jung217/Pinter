import 'package:flutter/material.dart';
import 'package:mypinter/config/l10n.dart';
import 'dart:math';

class PairingPage extends StatefulWidget {
  const PairingPage({super.key});

  @override
  State<PairingPage> createState() => _PairingPageState();
}

class _PairingPageState extends State<PairingPage> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> pets = [
    {"name": "Buddy", "breed": "Golden Retriever", "age": "2", "image": "https://images.dog.ceo/breeds/retriever-golden/n02099601_10.jpg"},
    {"name": "Max", "breed": "German Shepherd", "age": "3", "image": "https://images.dog.ceo/breeds/germanshepherd/n02106647_1049.jpg"},
    {"name": "Bella", "breed": "Labrador", "age": "1", "image": "https://images.dog.ceo/breeds/labrador/n02099712_1150.jpg"},
    {"name": "Charlie", "breed": "Poodle", "age": "4", "image": "https://images.dog.ceo/breeds/poodle-standard/n02113799_2280.jpg"},
    {"name": "Lucy", "breed": "Beagle", "age": "2", "image": "https://images.dog.ceo/breeds/beagle/n02088364_12102.jpg"},
    {"name": "Cooper", "breed": "Bulldog", "age": "3", "image": "https://images.dog.ceo/breeds/bulldog-french/n02108915_1223.jpg"},
  ];

  int currentIndex = 0;
  double _dragDistance = 0;
  double _dragAngle = 0;
  bool _isDragging = false;

  void _onSwipeLeft() {
    setState(() {
      if (currentIndex < pets.length - 1) {
        currentIndex++;
      }
    });
  }

  void _onSwipeRight() {
    setState(() {
      if (currentIndex < pets.length - 1) {
        currentIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context, 'pairing')),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          )
        ],
      ),
      body: currentIndex >= pets.length
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 80, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'No more pets!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for more matches',
                    style: TextStyle(color: colorScheme.secondary),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: const Text('Start Over'),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Background cards (next 2 cards)
                if (currentIndex + 2 < pets.length)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 100),
                      child: Transform.scale(
                        scale: 0.9,
                        child: _buildCard(pets[currentIndex + 2], isInteractive: false),
                      ),
                    ),
                  ),
                if (currentIndex + 1 < pets.length)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 100),
                      child: Transform.scale(
                        scale: 0.95,
                        child: _buildCard(pets[currentIndex + 1], isInteractive: false),
                      ),
                    ),
                  ),
                
                // Current card (swipeable)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          _isDragging = true;
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          _dragDistance += details.delta.dx;
                          _dragAngle = _dragDistance / 1000;
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          _isDragging = false;
                          if (_dragDistance > 100) {
                            _onSwipeRight();
                          } else if (_dragDistance < -100) {
                            _onSwipeLeft();
                          }
                          _dragDistance = 0;
                          _dragAngle = 0;
                        });
                      },
                      child: Transform.translate(
                        offset: Offset(_dragDistance, 0),
                        child: Transform.rotate(
                          angle: _dragAngle,
                          child: _buildCard(pets[currentIndex], isInteractive: true),
                        ),
                      ),
                    ),
                  ),
                ),

                // Action buttons
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Dislike button
                      FloatingActionButton(
                        heroTag: 'dislike',
                        onPressed: _onSwipeLeft,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.red[400], size: 32),
                      ),
                      const SizedBox(width: 40),
                      // Like button
                      FloatingActionButton(
                        heroTag: 'like',
                        onPressed: _onSwipeRight,
                        backgroundColor: colorScheme.primary,
                        child: const Icon(Icons.favorite, color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                ),

                // Swipe indicators
                if (_isDragging && _dragDistance.abs() > 50)
                  Positioned(
                    top: 100,
                    left: _dragDistance > 0 ? null : 40,
                    right: _dragDistance > 0 ? 40 : null,
                    child: Transform.rotate(
                      angle: _dragDistance > 0 ? -0.3 : 0.3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _dragDistance > 0 ? Colors.green : Colors.red,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _dragDistance > 0 ? 'LIKE' : 'NOPE',
                          style: TextStyle(
                            color: _dragDistance > 0 ? Colors.green : Colors.red,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildCard(Map<String, String> pet, {required bool isInteractive}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: isInteractive ? 8 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Pet image
          Image.network(
            pet['image']!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(
                  color: colorScheme.surfaceVariant,
                  child: const Center(
                    child: Icon(Icons.pets, size: 100, color: Colors.grey),
                  ),
                ),
          ),
          
          // Gradient overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          
          // Pet info
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      pet['name']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pet['age']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  pet['breed']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(Icons.location_on, '2 km away'),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.verified, 'Verified'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}