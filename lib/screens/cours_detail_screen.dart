import 'package:flutter/material.dart';
import '../models/cours.dart';

class CoursDetailScreen extends StatelessWidget {
  final Cours cours;
  const CoursDetailScreen({super.key, required this.cours});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cours.titre)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Chip(
              label: Text(cours.niveau.label),
              backgroundColor: Colors.indigo.shade50,
            ),
            const SizedBox(height: 16),
            Text(
              cours.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(cours.professeur),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text('${cours.dureeHeures} h'),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Ajouté le ${cours.createdAt.day}/${cours.createdAt.month}/${cours.createdAt.year}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}