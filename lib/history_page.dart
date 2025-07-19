import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal dan waktu

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<void> _deleteHistoryItem(String docId, String? imageUrl) async {
    try {
      // Delete from Firestore
      await FirebaseFirestore.instance.collection('history').doc(docId).delete();

      // Delete image from Firebase Storage if URL exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Note: refFromURL can throw an error if the URL is invalid or the object doesn't exist.
        // It's good practice to catch that specifically if needed.
        await FirebaseStorage.instance.refFromURL(imageUrl).delete();
      }
      print('Item deleted successfully!');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Klasifikasi'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('history').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]), // Ikon standar
                  const SizedBox(height: 16),
                  Text(
                    'Riwayat Kosong',
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hasil klasifikasi Anda akan muncul di sini.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          final historyDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {
              final doc = historyDocs[index];
              final data = doc.data() as Map<String, dynamic>;
              final String imageUrl = data['image_url'] ?? '';
              final String name = data['name'] ?? 'Unknown';
              final String description = data['description'] ?? 'No description.';
              final Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
              final String formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(timestamp.toDate());

              return Dismissible(
                key: Key(doc.id), // Unique key for Dismissible
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteHistoryItem(doc.id, imageUrl);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name dihapus')),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white, size: 36), // Ikon standar
                ),
                child: Card(
                  child: InkWell(
                    onTap: () {
                      // TODO: Implement view details logic (e.g., show a dialog with more info)
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(name),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  if (imageUrl.isNotEmpty)
                                    Image.network(imageUrl, height: 200, fit: BoxFit.cover)
                                  else
                                    Container(
                                      height: 200,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image_not_supported, size: 100, color: Colors.grey), // Fallback if no image
                                    ),
                                  const SizedBox(height: 16),
                                  Text('Jenis: $name', style: textTheme.titleMedium),
                                  const SizedBox(height: 8),
                                  Text('Deskripsi: $description', style: textTheme.bodyMedium),
                                  const SizedBox(height: 8),
                                  Text('Waktu: $formattedDate', style: textTheme.bodySmall),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Tutup'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          if (imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 80, color: Colors.grey); // Ikon standar
                                },
                              ),
                            )
                          else
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported, color: Colors.grey), // Ikon standar
                              ),
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: textTheme.titleLarge?.copyWith(fontSize: 18),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  description,
                                  style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  formattedDate,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, color: Colors.grey), // Ikon standar
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
}
