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

  // 🔥 MODELO TFLITE
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
    _loadModel(); // 🔥 carrega o modelo ao iniciar
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/soundclassifier_with_metadata.tflite',
      );
      setState(() {
        _modelLoaded = true;
      });
      //print("✅ Modelo carregado com sucesso");
    } catch (e) {
      //print("❌ Erro ao carregar modelo: $e");
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

              // 🔥 roda o modelo TFLite também
              String modelResult = _runModelDummy();
              //print(modelResult);
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

  // 🔥 CLASSIFICAÇÃO POR TEXTO (SEU MÉTODO ORIGINAL)
  String _classifyCommand(String text) {
    for (final cmd in comandos) {
      if (text.toLowerCase().contains(cmd)) {
        return 'Comando reconhecido: $cmd';
      }
    }
    return 'Comando não reconhecido';
  }

  // 🔥 EXECUTA O MODELO (entrada fake só para ativar o modelo)
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
