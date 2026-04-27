# XyrooSensix 🎯
**DPI & Sensitivity Controller — Flutter + Shizuku**

App untuk mengubah DPI layar, resolusi screen, dan sensitivity game menggunakan Shizuku (tanpa root).

---

## 📁 Struktur Project

```
xyroo_sensix/
├── lib/
│   ├── main.dart                    ← UI utama (semua halaman)
│   └── services/
│       └── shizuku_service.dart     ← Dart bridge ke Shizuku
├── android/
│   └── app/src/main/
│       ├── AndroidManifest.xml      ← Permissions
│       └── kotlin/com/xyroo/sensix/
│           └── MainActivity.kt      ← Native Kotlin bridge
├── pubspec.yaml
└── README.md
```

---

## 🔧 Cara Build

### 1. Install Flutter
```bash
# Download Flutter SDK
https://flutter.dev/docs/get-started/install/windows

# Verifikasi
flutter doctor
```

### 2. Setup Project
```bash
# Clone / buat project baru
flutter create xyroo_sensix
cd xyroo_sensix

# Copy semua file dari folder ini ke project
# Ganti lib/main.dart, android/..., pubspec.yaml
```

### 3. Tambahkan Shizuku Dependency (Android)

Edit `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'dev.rikka.shizuku:api:13.1.5'
    implementation 'dev.rikka.shizuku:provider:13.1.5'
}
```

Edit `android/build.gradle` (root):
```gradle
allprojects {
    repositories {
        google()
        mavenCentral()
        // Tambahkan ini:
        maven { url 'https://jitpack.io' }
    }
}
```

### 4. Update pubspec.yaml
```bash
flutter pub get
```

### 5. Build APK
```bash
# Debug APK (untuk test)
flutter build apk --debug

# Release APK (untuk distribusi)
flutter build apk --release

# APK ada di: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 Cara Pakai di HP

1. **Install Shizuku** dari Play Store
2. Aktifkan Shizuku via ADB atau Wireless Debugging:
   ```bash
   adb shell sh /sdcard/Android/data/moe.shizuku.privileged.api/start.sh
   ```
3. Install XyrooSensix APK
4. Buka app → Hubungkan Shizuku → Grant permission
5. Gunakan tab **DPI**, **Sens**, atau **Screen** sesuai kebutuhan

---

## 🎛️ Fitur

| Fitur | Keterangan |
|-------|-----------|
| DPI Controller | Ubah DPI layar (`wm density <nilai>`) |
| Screen Size | Ubah resolusi (`wm size WxH`) |
| Overscan Reset | Reset overscan (`wm overscan reset`) |
| Sensitivity | Preset sensitivity untuk Free Fire, PUBG, ML |
| Floating Window | Shortcut overlay di atas app lain |
| Shell Log | Tampilkan output perintah realtime |

---

## ⚠️ Catatan

- **Shizuku diperlukan** untuk fitur DPI & Screen Size
- DPI aman: **200–700** (di luar range bisa menyulitkan navigasi)
- Jika layar jadi tidak bisa digunakan, reset via ADB: `adb shell wm density reset`
- Sensitivity setting **tidak mengubah file game** — hanya saran nilai untuk input manual

---

## 🔄 Reset via ADB (jika HP tidak bisa dipakai)

```bash
adb shell wm density reset
adb shell wm size reset
adb shell wm overscan reset
```
