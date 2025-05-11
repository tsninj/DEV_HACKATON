import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Ashiglah zaavar
// final wavBytes = await synthesizeSpeech(
//   text,
//   voiceId: _voiceId,
//   speed: _speed,
//   pitch: _pitch,
// );

// voiceId: ['FEMALE1', 'FEMALE1v2', 'FEMALE2v2', 'FEMALE3v2', 'FEMALE4v2', 'FEMALE5v2', 'MALE1', 'MALE1v2', 'MALE2v2', 'MALE3v2', 'MALE4v2']
// speed: [ 0.2 .. 4 ]
// pitch: [ 0.2 .. 6 ]

class ChimegeService {
  static const _baseUrl = 'https://api.chimege.com/v1.2';

  /// Convert [text] to speech, returns WAV bytes.
  static Future<Uint8List> synthesizeSpeech(
    String text, {
    String voiceId   = 'FEMALE3v2',
    double speed     = 1.0,
    double pitch     = 1.0,
    int sampleRate   = 22050,
  }) async {
    // Read token at runtime, after dotenv.load()
    final token = dotenv.env['CHIMEGE_API'];
    if (token == null || token.isEmpty) {
      throw Exception('CHIMEGE_API_TOKEN is not set. Did you load .env?');
    }

    final uri = Uri.parse('$_baseUrl/synthesize');
    final headers = {
      'Content-Type': 'plain/text',
      'Token': token,
      'voice-id': voiceId,
      'speed': speed.toString(),
      'pitch': pitch.toString(),
      'sample-rate': sampleRate.toString(),
    };

    final response = await http.post(uri, headers: headers, body: text);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Synthesis failed: ${response.statusCode} - ${response.body}');
    }
  }
}