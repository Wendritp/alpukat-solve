# Blueprint Aplikasi Klasifikasi Daun Alpukat

## I. Ringkasan Proyek

Aplikasi ini bertujuan untuk mengklasifikasikan jenis daun alpukat menggunakan model machine learning, dengan fokus pada UI/UX yang modern, elegan, interaktif, dan mudah dipahami. Aplikasi akan dilengkapi dengan navigasi berbasis tab, fitur riwayat klasifikasi, dan pengaturan tema.

## II. Fitur & Desain Aplikasi (Versi Awal)

### 1. Tampilan dan Navigasi Utama
*   **Pendekatan:** Tab Navigation (Bottom Navigation Bar)
*   **Tab Utama:**
    *   **Home (Klasifikasi Daun Alpukat):** Tampilan utama untuk mengunggah gambar dan melihat hasil klasifikasi.
    *   **Riwayat Klasifikasi:** Menampilkan daftar riwayat klasifikasi yang disimpan.
    *   **Pengaturan (Settings):** Pengaturan aplikasi dan preferensi pengguna.
*   **Desain:** Minimalis, ikon yang jelas, ikon animasi responsif.

### 2. Desain Tampilan Utama (Klasifikasi Daun Alpukat - Tab Home)
*   **Layout:**
    *   **Header:** Judul aplikasi ("Klasifikasi Daun Alpukat").
    *   **Instruksi:** Panduan singkat untuk pengguna.
    *   **Tombol Unggah Gambar:** Tombol besar dengan ikon kamera/galeri, animasi halus saat disentuh.
*   **Tampilan Gambar & Hasil:**
    *   **Gambar Daun Alpukat:** Gambar yang diunggah, responsif.
    *   **Nama Jenis Alpukat:** Font tebal dan jelas (e.g., "Alpukat Madu").
    *   **Deskripsi:** Deskripsi singkat dan bermanfaat.
    *   **Probabilitas:** Persentase dengan progress bar visualisasi.
*   **Tombol Simpan Riwayat:** Tombol "Simpan ke Riwayat" dengan efek hover/animasi.

### 3. Desain Tampilan Riwayat Klasifikasi (Tab Riwayat)
*   **Layout:**
    *   **Daftar Riwayat:** Kartu elegan untuk setiap item.
    *   **Tampilan Kartu:** Desain kartu sederhana, bersih, bayangan halus. Setiap kartu berisi gambar, nama jenis, deskripsi singkat, dan timestamp.
*   **Fitur Interaktif:**
    *   **Swipe untuk Menghapus:** Geser kartu untuk menghapus riwayat.
    *   **Tombol Lihat Detail:** Tombol kecil di setiap kartu untuk melihat detail lebih lanjut.

### 4. Desain Tampilan Pengaturan (Tab Pengaturan)
*   **Layout:**
    *   **Tema Gelap/Terang:** Tombol switch dengan animasi transisi halus.
    *   **Kontak & Tentang:** Informasi aplikasi (Tentang Aplikasi, Kontak Kami, Kebijakan Privasi).
*   **Fitur Interaktif:**
    *   **Tombol Simpan Pengaturan:** Untuk menyimpan perubahan preferensi.

### 5. Desain Visual dan Interaksi UI
*   **Warna & Tema:**
    *   **Skema Warna:** Warna alami dan sejuk (hijau muda, putih, abu-abu gelap).
    *   **Efek Hover & Animasi:** Pada tombol dan ikon untuk umpan balik langsung.
*   **Font:** Jelas dan mudah dibaca (Roboto, Poppins untuk teks utama; Montserrat untuk judul).
*   **Transisi & Animasi:** Halus antar layar.
*   **Progress Indicator:** Saat gambar diproses.

### 6. Responsivitas dan Skalabilitas
*   **Desain Responsif:** Mendukung berbagai ukuran layar (smartphone, tablet).
*   **UI yang Mudah Diakses:** Teks cukup besar, kontras warna memadai.

### 7. Fitur Interaktif dan Umpan Balik Pengguna
*   **Push Notifications:** Opsional, untuk notifikasi berhasil simpan klasifikasi.
*   **Tombol Kembali:** Jelas di halaman klasifikasi atau riwayat.

### 8. Teknologi & Dependensi (Awal)
*   **Flutter SDK:** Sesuai instruksi (`minSdkVersion 21`, `targetSdkVersion 33`).
*   **Dependencies (pubspec.yaml):**
    *   `cupertino_icons`: Untuk ikon iOS.
    *   `image_picker`: Untuk mengambil gambar dari galeri/kamera.
    *   `google_fonts`: Untuk kustomisasi font.
    *   `provider`: Untuk manajemen state (khususnya tema).
    *   Tambahan: `firebase_core`, `firebase_ai` (untuk klasifikasi, akan diintegrasikan nanti).
*   **Assets:**
    *   `assets/model.tflite`
    *   `assets/labels.txt`
    *   `assets/icon/app_icon.png`

## III. Rencana Implementasi Saat Ini

1.  **Perbarui `pubspec.yaml`**: Tambahkan `image_picker`, `google_fonts`, dan `provider` sebagai dependensi. Pastikan deklarasi aset sudah benar.
2.  **Perbarui `android/app/build.gradle.kts`**: Set `minSdkVersion 21` dan `targetSdkVersion 33`.
3.  **Buat `lib/theme_provider.dart`**: Implementasi `ThemeProvider` untuk manajemen tema.
4.  **Buat `lib/home_page.dart`**: Implementasi halaman utama untuk klasifikasi.
5.  **Buat `lib/history_page.dart`**: Implementasi halaman riwayat.
6.  **Buat `lib/settings_page.dart`**: Implementasi halaman pengaturan.
7.  **Modifikasi `lib/main.dart`**: Atur struktur aplikasi utama dengan `MaterialApp`, `ChangeNotifierProvider`, dan `BottomNavigationBar`.
8.  **Integrasi Google Fonts & Color Scheme**: Terapkan tema warna dan font sesuai spesifikasi.
9.  **Dummy Data & UI Dummy**: Gunakan data dummy untuk menampilkan UI klasifikasi dan riwayat.
10. **Lakukan `flutter pub get`** setelah perubahan `pubspec.yaml`.
11. **Jalankan `flutter run`** untuk memverifikasi tampilan awal.
