import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:omikuji_app/constants/prompts.dart';

class GeminiClient {
  GeminiClient._();

  static final GeminiClient instance = GeminiClient._();

  static final _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
  );

  Future<String> generateMessageByGemini({required String inputText}) async {
    String message = '';
    final content = [
      Content.text(Prompts.common),
      Content.text(inputText),
    ];
    try {
      final response = await _model.generateContent(content);
      message = response.text ?? '';
    } catch (e) {
      throw Exception(e);
    }
    return message;
  }
}
