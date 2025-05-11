import 'package:flutter/material.dart';

class VolunteerCard extends StatelessWidget {
  const VolunteerCard({
    super.key,
    required this.name,
    required this.photoProvider,
    required this.description,
    required this.icon,
    required this.date,
  });

  final String name;
  final ImageProvider photoProvider;
  final String description;
  final IconData icon;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 260, // Increased for better spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image with clipped rounded corners
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image(
              image: photoProvider,
              width: double.infinity,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 130,
                color: Colors.grey,
                child: const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
          // Text and details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and icon/date row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(icon, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
