import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reconhecimento de Voz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const VoiceCommandPage(),
    );
  }
}

class VoiceCommandPage extends StatefulWidget {
  const VoiceCommandPage({super.key});

  @override
  State<VoiceCommandPage> createState() => _VoiceCommandPageState();
}

class _VoiceCommandPageState extends State<VoiceCommandPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recognizedText = 'Pressione o botão e fale um comando.';
  String _commandResult = '';
  String _modelResultText = '';
  String _imagePath = 'assets/imagens/aguardando.png';

  late Interpreter _interpreter;
  bool _modelLoaded = false;

  final List<String> comandos = [
    'cima',
    'baixo',
    'esquerdo',
    'direito',
    'ligado',
    'desligado',
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/soundclassifier_with_metadata.tflite',
      );
      setState(() => _modelLoaded = true);
    } catch (e) {
      debugPrint("Erro ao carregar modelo: $e");
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _recognizedText = result.recognizedWords;
              _commandResult = _classifyCommand(_recognizedText);
              _modelResultText = _runModelDummy();
            });
          },
          localeId: 'pt_BR',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  String _classifyCommand(String text) {
    for (final cmd in comandos) {
      if (text.toLowerCase().contains(cmd)) {
        _updateImage(cmd);
        return 'Comando reconhecido: $cmd';
      }
    }
    _updateImage('aguardando');
    return 'Comando não reconhecido';
  }

  void _updateImage(String comando) {
    _imagePath = 'assets/imagens/$comando.png';
  }

  String _runModelDummy() {
    if (!_modelLoaded) return "Modelo ainda não carregado";

    var input = List.generate(1, (_) => List.filled(40, 0.0));
    var output = List.generate(1, (_) => List.filled(6, 0.0));

    _interpreter.run(input, output);

    final labels = [
      'cima',
      'baixo',
      'esquerdo',
      'direito',
      'ligado',
      'desligado',
    ];

    double maxScore = 0;
    int maxIndex = -1;

    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > maxScore) {
        maxScore = output[0][i];
        maxIndex = i;
      }
    }

    if (maxIndex != -1) {
      return 'Modelo TFLite: ${labels[maxIndex]} (${(maxScore * 100).toStringAsFixed(1)}%)';
    }

    return 'Modelo não reconheceu comando';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reconhecimento de Voz')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(_imagePath, height: 150),
              const SizedBox(height: 20),
              Text(
                _recognizedText,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _commandResult,
                style: const TextStyle(fontSize: 20, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _modelResultText,
                style: const TextStyle(fontSize: 18, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FloatingActionButton(
                onPressed: _listen,
                child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
