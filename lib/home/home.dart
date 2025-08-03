import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'dart:io' show Platform;

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  final GoogleTranslator _translator = GoogleTranslator();
  Map<String, List<Map<String, String>>> _languageVoices = {};

  // Initialize the service and fetch the available voices from the device.
  Future<void> initialize() async {
    if (Platform.isIOS) {
      await _flutterTts.setSharedInstance(true);
    }

    try {
      var voices = await _flutterTts.getVoices as List;
      for (var voice in voices) {
        final voiceMap = voice as Map;
        final lang = (voiceMap['locale'] as String);
        _languageVoices.putIfAbsent(lang, () => []);
        _languageVoices[lang]!.add({'name': voiceMap['name'], 'locale': lang});
      }
    } catch (e) {
      print("Error initializing TTS service: $e");
    }
  }

  // The main function to perform the translation and speaking.
  // It returns the translated text so the UI can display it.
  Future<String> translateAndSpeak({
    required String textToTranslate,
    required String targetLanguageCode,
    required int currentVoiceIndex,
  }) async {
    // 1. Translate the text
    final languageShortCode = targetLanguageCode.split('-')[0];
    final translation = await _translator.translate(textToTranslate, to: languageShortCode);
    final translatedText = translation.text;

    // 2. Find available voices for the target language
    final voices = _languageVoices[targetLanguageCode];
    if (voices == null || voices.isEmpty) {
      throw Exception("TTS for '$targetLanguageCode' is not supported on this device.");
    }

    // 3. Set up and speak the translated text
    final voiceToUse = voices[currentVoiceIndex];
    await _flutterTts.setLanguage(targetLanguageCode);
    await _flutterTts.setVoice(voiceToUse);
    await _flutterTts.speak(translatedText);

    // 4. Return the result to the UI
    return translatedText;
  }

  // A simple helper for the UI to get the number of available voices.
  int getVoiceCountForLanguage(String languageCode) {
    return _languageVoices[languageCode]?.length ?? 0;
  }

  // A helper to get the name of the next voice for display purposes.
  String getNextVoiceName(String languageCode, int nextIndex) {
    final voices = _languageVoices[languageCode];
    if (voices == null || voices.isEmpty) return 'N/A';
    return voices[nextIndex]['name'] ?? 'Unknown Voice';
  }

  void stop() {
    _flutterTts.stop();
  }
}


class TtsScreen extends StatefulWidget {
  final TtsService ttsService; // Receives the service

  const TtsScreen({Key? key, required this.ttsService}) : super(key: key);

  @override
  _TtsScreenState createState() => _TtsScreenState();
}

class _TtsScreenState extends State<TtsScreen> {
  // UI State - Variables that control what the user sees
  final TextEditingController _textController = TextEditingController(text: 'Hello, I love Flutter!');
  String? _selectedLanguageCode;
  int _currentVoiceIndex = 0;
  bool _isProcessing = false;
  String _resultText = '';
  String _errorMessage = '';

  // A predefined list of languages for our dropdown menu
  final Map<String, String> _languages = {
    'Urdu': 'ur-PK',
    'English': 'en-US',
    'French': 'fr-FR',
    'Spanish': 'es-ES',
    'German': 'de-DE',
    'Japanese': 'ja-JP',
    'Russian': 'ru-RU',
  };

  @override
  void initState() {
    super.initState();
    // Set a default language when the app starts
    _selectedLanguageCode = _languages.values.first;

    // Initialize our service
    widget.ttsService.initialize().then((_) {
      // Refresh the UI after initialization is complete
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    widget.ttsService.stop();
    super.dispose();
  }

  // This is the function called when the user presses the main button.
  Future<void> _handleProcessing() async {
    if (_textController.text.isEmpty || _selectedLanguageCode == null || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = '';
      _resultText = 'Processing...';
    });

    try {
      // Ask the service to do the work
      final translatedText = await widget.ttsService.translateAndSpeak(
        textToTranslate: _textController.text,
        targetLanguageCode: _selectedLanguageCode!,
        currentVoiceIndex: _currentVoiceIndex,
      );

      // If successful, update the UI with the result and cycle the voice
      final voiceCount = widget.ttsService.getVoiceCountForLanguage(_selectedLanguageCode!);
      setState(() {
        _resultText = translatedText;
        if (voiceCount > 0) {
          _currentVoiceIndex = (_currentVoiceIndex + 1) % voiceCount;
        }
      });
    } catch (e) {
      // If an error occurs, update the UI to show the error
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _resultText = '';
      });
    } finally {
      // Always ensure the loading state is turned off
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TTS-Multi Languages'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter text to translate',
                border: OutlineInputBorder(),
              ),
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Translate and speak in this language',
                border: OutlineInputBorder(),
              ),
              value: _selectedLanguageCode,
              items: _languages.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.value,
                  child: Text(entry.key),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedLanguageCode = newValue;
                  _currentVoiceIndex = 0; // Reset voice index
                  _resultText = '';       // Clear old results
                  _errorMessage = '';
                });
              },
            ),
            const SizedBox(height: 20),

            // 3. Action Button
            ElevatedButton.icon(
              icon: _isProcessing
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Icon(Icons.volume_up),
              label: Text(_isProcessing ? 'Working...' : 'Translate & Play'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: _handleProcessing,
            ),
            const SizedBox(height: 30),

            // 4. Result and Info Display Area
            _buildResultInfo(),
          ],
        ),
      ),
    );
  }

  // A helper widget to neatly display the results or errors.
  Widget _buildResultInfo() {
    if (_resultText.isEmpty && _errorMessage.isEmpty) {
      return const SizedBox.shrink(); // Show nothing if there's no result yet
    }

    // Determine the next voice name for display
    String nextVoiceInfo = '';
    if (_selectedLanguageCode != null) {
      final voiceCount = widget.ttsService.getVoiceCountForLanguage(_selectedLanguageCode!);
      if (voiceCount > 0) {
        final nextVoiceName = widget.ttsService.getNextVoiceName(_selectedLanguageCode!, _currentVoiceIndex);
        nextVoiceInfo = "Next voice: $nextVoiceName ($voiceCount total)";
      } else {
        nextVoiceInfo = "No TTS voices found for this language.";
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _errorMessage.isNotEmpty ? Colors.red.withOpacity(0.1) : Colors.teal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show either the result or an error message
          if (_errorMessage.isNotEmpty)
            Text('Error: $_errorMessage', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
          else
            Text(_resultText, style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),

          const Divider(height: 24),
          Text(nextVoiceInfo, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}