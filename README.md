## 🗣️ TTS Multi-Language Translator App

This Flutter app allows users to input any text, translate it into multiple languages, 
and use Text-to-Speech (TTS) to speak the translated text aloud with different voice options available on the device.
### 📽 App Demo

[![Watch the demo](https://github.com/tanveerkhan87/Multilingual_TTS/raw/main/demo.gif)](https://drive.google.com/uc?export=view&id=1SkZQhKoJSGQWKBhJKIwtH3Jc59efJ50J)






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

⚠️ Limitations
❗ TTS Voices depend on the device's installed engines.

🔄 Voice Switching works only if multiple voices are available.

📶 Internet Required for translation to work.

🌐 Unofficial API: translator uses an unofficial Google Translate endpoint and may break or throttle under load.








