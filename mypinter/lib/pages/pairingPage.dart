import 'package:flutter/material.dart';
import 'package:mypinter/config/l10n.dart';

class PairingPage extends StatelessWidget {
  const PairingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> pets = [
      {"name": "Buddy", "breed": "Golden Retriever", "image": "https://images.dog.ceo/breeds/retriever-golden/n02099601_10.jpg"},
      {"name": "Max", "breed": "German Shepherd", "image": "https://images.dog.ceo/breeds/germanshepherd/n02106647_1049.jpg"},
      {"name": "Bella", "breed": "Labrador", "image": "https://images.dog.ceo/breeds/labrador/n02099712_1150.jpg"},
      {"name": "Charlie", "breed": "Poodle", "image": "https://images.dog.ceo/breeds/poodle-standard/n02113799_2280.jpg"},
      {"name": "Lucy", "breed": "Beagle", "image": "https://images.dog.ceo/breeds/beagle/n02088364_12102.jpg"},
      {"name": "Cooper", "breed": "Bulldog", "image": "https://images.dog.ceo/breeds/bulldog-french/n02108915_1223.jpg"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context, 'pairing')),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    pet['image']!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.pets, size: 50, color: Colors.grey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pet['breed']!,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}