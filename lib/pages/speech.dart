import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextView extends StatefulWidget {
  const SpeechToTextView({super.key});

  @override
  State<SpeechToTextView> createState() => _SpeechToTextViewState();
}

class _SpeechToTextViewState extends State<SpeechToTextView> {
  bool _hasSpeech = false;
  final SpeechToText speech = SpeechToText();
  double level = 0.0;
  String lastWords = '';
  String lastError = '';

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
      );
      if (!mounted) return;
      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Error inicializando reconocimiento de voz: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  void startListening() {
    setState(() {
      lastWords = '';
      lastError = '';
    });
    speech.listen(
      onResult: resultListener,
      onSoundLevelChange: soundLevelListener,
      localeId: 'es_ES',
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  void soundLevelListener(double level) {
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = error.errorMsg;
    });
  }

  void statusListener(String status) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Voz a texto',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SpeechControlWidget(
              _hasSpeech,
              speech.isListening,
              startListening,
              stopListening,
            ),
            const SizedBox(height: 20),
            RecognitionResultsWidget(lastWords: lastWords, level: level),
            const SizedBox(height: 20),
            ErrorWidget(lastError: lastError),
            const SizedBox(height: 20),
            SpeechStatusWidget(speech: speech),
          ],
        ),
      ),
    );
  }
}

class SpeechControlWidget extends StatelessWidget {
  const SpeechControlWidget(
      this.hasSpeech, this.isListening, this.startListening, this.stopListening,
      {super.key});

  final bool hasSpeech;
  final bool isListening;
  final void Function() startListening;
  final void Function() stopListening;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: !hasSpeech || isListening ? null : startListening,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text('Escuchar'),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: isListening ? stopListening : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text('Detener'),
        ),
      ],
    );
  }
}

class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({super.key, required this.lastWords, required this.level});

  final String lastWords;
  final double level;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Palabras reconocidas:',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 2,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  lastWords.isNotEmpty ? lastWords : 'Habla algo para comenzar...',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          MicLevelIndicator(level: level),
        ],
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key, required this.lastError});

  final String lastError;

  @override
  Widget build(BuildContext context) {
    return Text(
      lastError.isNotEmpty ? 'Error: $lastError' : '',
      style: const TextStyle(color: Colors.red),
    );
  }
}

class SpeechStatusWidget extends StatelessWidget {
  const SpeechStatusWidget({super.key, required this.speech});

  final SpeechToText speech;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          speech.isListening ? "Escuchando..." : 'Micrófono apagado',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class MicLevelIndicator extends StatelessWidget {
  const MicLevelIndicator({super.key, required this.level});

  final double level;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: level * 1.5,
          ),
        ],
      ),
      child: const Icon(
        Icons.mic,
        color: Colors.blueAccent,
        size: 30,
      ),
    );
  }
}