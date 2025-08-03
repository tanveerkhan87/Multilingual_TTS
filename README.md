## 🗣️ TTS Multi-Language Translator App

This Flutter app allows users to input any text, translate it into multiple languages, 
and use Text-to-Speech (TTS) to speak the translated text aloud with different voice options available on the device.

### 🚀 Features

* 🌍 Translate text into multiple languages
* 🗣️ Speak translated text using Flutter TTS
* 🔄 Cycles through available voices for each language
* 📱 Compatible with Android and iOS
* 🎯 User-friendly interface with dropdown selection



### 🛠️ Setup Instructions

1. **Clone the Repository**

   ```bash
   git clone https://github.com/tanveerkhan87/Multilingual_TTS.git
   cd Multilingual_TTS


2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Ensure Required Packages Are Added in `pubspec.yaml`:**

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     flutter_tts: ^3.8.0
     translator: ^0.1.7
   ```

4. **Run the App**

   ```bash
   flutter run
   ```

---

---

### 🌐 Supported Languages

* Urdu (`ur-PK`)
* English (`en-US`)
* French (`fr-FR`)
* Spanish (`es-ES`)
* German (`de-DE`)
* Japanese (`ja-JP`)
* Russian (`ru-RU`)

---

### ⚠️ Known Limitations or Assumptions

* ❗ **Device Dependency**: Voice availability depends on the device's installed TTS engines.
* 🔄 **Voice Index Cycles**: The app cycles voices only if multiple TTS voices are installed.
* 📶 **Internet Required**: Translation uses the Google Translate API, which requires an active internet connection.
* 🌐 **Google Translate API Limitations**: The free `translator` package uses an unofficial endpoint, which may break or throttle under high usage.

