// lib/history_page.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<void> _deleteHistoryItem(String docId) async {
    await FirebaseFirestore.instance.collection('history').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final theme     = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Klasifikasi')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Riwayat Kosong', style: textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Hasil klasifikasi Anda akan muncul di sini.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc  = docs[index];
              final data = doc.data()! as Map<String, dynamic>;

              final name        = data['name'] as String? ?? 'Unknown';
              final description = data['description'] as String? ?? '';
              final timestamp   = data['timestamp'] as Timestamp? ?? Timestamp.now();
              final dateStr     = DateFormat('dd MMM yyyy, HH:mm')
                  .format(timestamp.toDate());

              // 1) Ambil Blob dari Firestore
              final Blob? storedBlob = data['image_blob'] as Blob?;
              // 2) Ambil bytes
              final Uint8List? imageBytes = storedBlob?.bytes;

              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  _deleteHistoryItem(doc.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name dihapus')),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white, size: 36),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () => _showDetailDialog(
                        context, name, description, dateStr, imageBytes, textTheme),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: imageBytes != null
                                ? Image.memory(
                              imageBytes,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: textTheme.titleLarge
                                        ?.copyWith(fontSize: 18)),
                                const SizedBox(height: 4),
                                Text(
                                  description,
                                  style: textTheme.bodyMedium
                                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(dateStr,
                                    style: textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey[500])),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetailDialog(
      BuildContext context,
      String name,
      String description,
      String dateStr,
      Uint8List? imageBytes,
      TextTheme textTheme,
      ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    imageBytes,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text('Jenis: $name', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Deskripsi: $description', style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Waktu: $dateStr', style: textTheme.bodySmall),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
