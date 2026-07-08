# Student Assessment WebView

🇮🇩 Bahasa Indonesia | [English](#english)

Aplikasi Android berbasis Flutter yang berfungsi sebagai **WebView Wrapper** untuk menjalankan aplikasi **Student Assessment**. Setelah diinstal, aplikasi akan mengakses URL assessment dan memberikan pengalaman seperti aplikasi Android native.

Aplikasi ini dirancang agar pengguna (siswa) dapat mengakses ujian dengan lebih mudah tanpa harus membuka browser secara langsung.

---

## Fitur

- Menjalankan aplikasi Student Assessment melalui WebView
- Mendukung Progressive Web App (PWA)
- Tampilan fullscreen
- Pengalaman seperti aplikasi Android native
- Navigasi sederhana dan ringan
- Mendukung instalasi langsung pada perangkat Android

---

## Tech Stack

- Flutter
- webview_flutter
- Android SDK

---

## Persyaratan

- Flutter SDK 3.x atau lebih baru
- Android Studio
- Android SDK
- Perangkat Android atau Emulator

---

## Instalasi

### Clone Repository

```bash
git clone https://github.com/USERNAME/student-assessment-webview.git
cd student-assessment-webview
```

### Install Dependency

```bash
flutter pub get
```

### Jalankan

```bash
flutter run
```

---

## Build APK

Debug

```bash
flutter build apk
```

Release

```bash
flutter build apk --release
```

---

## Konfigurasi URL

URL aplikasi assessment dapat diubah pada file konfigurasi sesuai kebutuhan.

Contoh:

```dart
const String baseUrl = "https://assessment.example.com";
```

---

## Cara Kerja

1. Pengguna menginstal aplikasi Android.
2. Aplikasi membuka URL Student Assessment menggunakan WebView.
3. Website berjalan sebagai Progressive Web App (PWA).
4. Pengguna dapat mengerjakan assessment layaknya menggunakan aplikasi Android.

---

## Screenshot

Tambahkan screenshot aplikasi di sini.

```
screenshots/
├── splash.png
├── login.png
├── dashboard.png
└── assessment.png
```

---

## License

This project is licensed under the MIT License.

---

# English

Student Assessment WebView is a Flutter-based Android application that acts as a **WebView Wrapper** for the Student Assessment system.

Instead of opening the assessment website in a browser, users can launch it directly from an Android application, providing a more native and user-friendly experience.

---

## Features

- Launches the Student Assessment web application inside WebView
- Supports Progressive Web Apps (PWA)
- Fullscreen experience
- Lightweight and easy to use
- Native-like Android experience
- Simple navigation

---

## Tech Stack

- Flutter
- webview_flutter
- Android SDK

---

## Requirements

- Flutter SDK 3.x or newer
- Android Studio
- Android SDK
- Android device or emulator

---

## Installation

### Clone Repository

```bash
git clone https://github.com/USERNAME/student-assessment-webview.git
cd student-assessment-webview
```

### Install Dependencies

```bash
flutter pub get
```

### Run

```bash
flutter run
```

---

## Build APK

Debug

```bash
flutter build apk
```

Release

```bash
flutter build apk --release
```

---

## Configure URL

Update the assessment server URL inside the configuration file.

Example:

```dart
const String baseUrl = "https://assessment.example.com";
```

---

## How It Works

1. Install the Android application.
2. The application opens the Student Assessment website inside a WebView.
3. The website runs as a Progressive Web App (PWA).
4. Users can complete assessments with a native app-like experience.

---

## Screenshots

Place application screenshots inside:

```
screenshots/
├── splash.png
├── login.png
├── dashboard.png
└── assessment.png
```

---

## License

This project is licensed under the MIT License.
