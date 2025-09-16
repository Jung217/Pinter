import 'package:flutter/material.dart';
import 'package:ritual/services/constants.dart';

class CustomImagePicker extends StatelessWidget {
  const CustomImagePicker({super.key, required this.onImageSelected, required this.cardIllustrations});

  final Function(String) onImageSelected; // Callback function
  final Map cardIllustrations;

  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: Constants.illustrations.map((image) {
              return GestureDetector(
                onTap: () {
                  // Send the selected image filename back to the calling function
                  onImageSelected(image);
                  Navigator.pop(
                      context); // Close the dialog after selecting an image
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      height: 100,
                      width: double.infinity,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
