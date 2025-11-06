import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final String imagePath;

  const ImageButton({
    super.key, 
    required this.label, 
    required this.onTap,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ⬆️ Text label with white background
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 215, 216, 163),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'ChalkboardSE',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ⬇️ Button below with image
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 200,
            height: 190,
            decoration: BoxDecoration(
              color: Colors.teal.shade100,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
