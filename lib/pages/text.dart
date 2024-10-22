import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechView extends StatefulWidget {
  const TextToSpeechView({super.key});

  @override
  State<TextToSpeechView> createState() => _TextToSpeechViewState();
}

enum TtsState { playing, stopped, paused, continued }

class _TextToSpeechViewState extends State<TextToSpeechView> {
  late FlutterTts flutterTts;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String? _newVoiceText;
  TtsState ttsState = TtsState.stopped;

  bool get isPlaying => ttsState == TtsState.playing;

  @override
  void initState() {
    super.initState();
    initTts();
  }

  void initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<void> _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null && _newVoiceText!.isNotEmpty) {
      await flutterTts.speak(_newVoiceText!);
    }
  }

  Future<void> _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future<void> _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  void _onChange(String text) {
    setState(() {
      _newVoiceText = text;
    });
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Texto a Voz',
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _inputSection(),
              const SizedBox(height: 20),
              _btnSection(),
              const SizedBox(height: 20),
              _buildSliders(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputSection() => Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          maxLines: 6,
          minLines: 3,
          onChanged: _onChange,
          onSubmitted: (value) {
            _hideKeyboard();
            _speak();
          },
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            labelText: 'Introduce el texto a convertir en voz',
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );

  Widget _btnSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(Colors.green, Icons.play_arrow, 'PLAY', _speak),
        _buildButtonColumn(Colors.red, Icons.stop, 'STOP', _stop),
        _buildButtonColumn(Colors.blue, Icons.pause, 'PAUSE', _pause),
      ],
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label, Function func) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon),
          color: color,
          onPressed: () => func(),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12.0, color: color)),
      ],
    );
  }

  Widget _buildSliders() {
    return Column(
      children: [_volumeSlider(), _pitchSlider(), _rateSlider()],
    );
  }

  Widget _volumeSlider() {
    return Slider(
      value: volume,
      onChanged: (newVolume) {
        setState(() => volume = newVolume);
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Volume: $volume",
    );
  }

  Widget _pitchSlider() {
    return Slider(
      value: pitch,
      onChanged: (newPitch) {
        setState(() => pitch = newPitch);
      },
      min: 0.5,
      max: 2.0,
      divisions: 15,
      label: "Pitch: $pitch",
      activeColor: Colors.red,
    );
  }

  Widget _rateSlider() {
    return Slider(
      value: rate,
      onChanged: (newRate) {
        setState(() => rate = newRate);
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $rate",
      activeColor: Colors.green,
    );
  }
}