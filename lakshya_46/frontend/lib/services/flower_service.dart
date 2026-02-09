import 'package:http/http.dart' as http;
import '../models/flower.dart';
import '../utils/cloudinary_service.dart';
import 'dart:convert';
// import 'dart:io';
import 'dart:typed_data';

class FlowerService {
  static String API_URL = 'http://localhost:4000/flowers';

  // Web / Chrome specific addFlower method - existing one remains unchanged
  static Future<Map<String, dynamic>> addFlowerWeb({
    required name,
    required description,
    Uint8List? imageBytes,
    Uint8List? pdfBytes,
  }) async {
    String? imageUrl;
    String? pdfUrl;

    if (imageBytes != null) {
      imageUrl = await CloudinaryService.uploadImageBytesWeb(imageBytes);
    }

    if (pdfBytes != null) {
      pdfUrl = await CloudinaryService.uploadPdfBytesWeb(pdfBytes);
    }

    final response = await http.post(
      Uri.parse(API_URL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'pdfUrl': pdfUrl,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      if (imageUrl != null) {
        await CloudinaryService.deleteImageBytesWeb(imageUrl);
      }

      if (pdfUrl != null) {
        await CloudinaryService.deletePdfBytesWeb(pdfUrl);
      }

      return jsonDecode(response.body);
    }
  }

  static Future<List<dynamic>> getFlowers() async {
    final response = await http.get(Uri.parse(API_URL));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map<Flower>(
            (flower) => Flower.fromJson(flower as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Failed to load flowers');
    }
  }

  static Future<Map<String, dynamic>> editFlowerWeb({
    required id,
    required name,
    required description,
    Uint8List? imageBytes,
    Uint8List? pdfBytes,
    required oldImageURL,
    required oldPdfURL,
  }) async {
    String? imageUrl = oldImageURL;
    String? pdfUrl = oldPdfURL;

    if (imageBytes != null) {
      imageUrl = await CloudinaryService.uploadImageBytesWeb(imageBytes);
    }

    if (pdfBytes != null) {
      pdfUrl = await CloudinaryService.uploadPdfBytesWeb(pdfBytes);
    }

    final response = await http.put(
      Uri.parse('$API_URL/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'imageUrl': imageUrl ?? oldImageURL,
        'pdfUrl': pdfUrl ?? oldPdfURL,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteFlower(String id) async {
    final response = await http.delete(Uri.parse('${API_URL}/$id'));
    return jsonDecode(response.body);
  }
}
