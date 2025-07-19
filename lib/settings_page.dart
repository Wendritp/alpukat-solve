import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildSectionTitle(context, 'Tampilan'),
          _buildThemeToggle(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Informasi'),
          _buildInfoTile(
            context,
            icon: Icons.info_outline, // Diperbaiki
            title: 'Tentang Aplikasi',
            subtitle: 'Versi 1.0.0',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Klasifikasi Daun Alpukat',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2023 All rights reserved.',
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Aplikasi ini membantu Anda mengklasifikasi jenis daun alpukat menggunakan model machine learning.',
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              );
            },
          ),
          _buildInfoTile(
            context,
            icon: Icons.contact_mail_outlined, // Diperbaiki
            title: 'Kontak Kami',
            subtitle: 'Hubungi kami untuk dukungan',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur kontak kami segera hadir!')),
              );
              // TODO: Implement actual contact functionality (e.g., email client)
            },
          ),
          _buildInfoTile(
            context,
            icon: Icons.privacy_tip_outlined, // Diperbaiki
            title: 'Kebijakan Privasi',
            subtitle: 'Baca kebijakan privasi kami',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur kebijakan privasi segera hadir!')),
              );
              // TODO: Implement actual privacy policy view (e.g., open webview)
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      child: SwitchListTile(
        title: Text('Tema Gelap', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        secondary: const Icon(Icons.dark_mode_rounded),
        value: themeProvider.themeMode == ThemeMode.dark,
        onChanged: (value) {
          themeProvider.toggleTheme();
        },
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleLarge?.copyWith(fontSize: 18)),
        subtitle: Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
