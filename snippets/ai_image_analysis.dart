// Tafaqd - Sending an item photo to the AI service (excerpt)
//
// Used in two places:
//   - Staff side:    a photo of a found item is analyzed to pre-fill its
//                    category and description before it is registered.
//   - Traveler side: a photo of the lost item is turned into a caption,
//                    which is then used to search the registered items.
//
// The AI service receives the image and responds with JSON:
//   { "class": "<predicted category>", "caption": "<generated description>" }

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

/// Base URL of the AI inference service (configured per deployment).
const String kInferenceEndpoint = '<AI_SERVICE_URL>/tafaqd';

class ModelResponse {
  final String class1;
  final String caption;

  ModelResponse({required this.class1, required this.caption});

  factory ModelResponse.fromJson(Map<String, dynamic> json) {
    return ModelResponse(
      class1: json['class'] ?? "",
      caption: json['caption'] ?? "",
    );
  }
}

Future<ModelResponse?> analyzeItemImage(File file) async {
  final String? mimeType = lookupMimeType(file.path);
  final String mainType = mimeType?.split('/')[0] ?? 'image';
  final String subType = mimeType?.split('/')[1] ?? 'jpeg';

  final request = http.MultipartRequest('POST', Uri.parse(kInferenceEndpoint));
  request.files.add(
    http.MultipartFile(
      'file',
      file.readAsBytes().asStream(),
      await file.length(),
      filename: basename(file.path),
      contentType: MediaType(mainType, subType),
    ),
  );

  final response = await request.send();
  if (response.statusCode != 200) return null;

  final body = await response.stream.bytesToString();
  return ModelResponse.fromJson(jsonDecode(body));
}
