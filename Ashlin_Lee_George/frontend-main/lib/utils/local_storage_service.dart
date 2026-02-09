import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<String> saveImageFile(File imageFile) async {
    try {
      // Get the application documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String imagesDirPath = path.join(appDir.path, 'flower_images');
      
      // Create images directory if it doesn't exist
      final Directory imagesDir = Directory(imagesDirPath);
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      // Generate unique filename
      final String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final String filePath = path.join(imagesDirPath, fileName);
      
      // Copy file to local storage
      await imageFile.copy(filePath);
      
      return filePath;
    } catch (e) {
      throw Exception('Failed to save image file: $e');
    }
  }
  
  static Future<String> savePdfFile(File pdfFile) async {
    try {
      // Get the application documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String pdfsDirPath = path.join(appDir.path, 'flower_pdfs');
      
      // Create PDFs directory if it doesn't exist
      final Directory pdfsDir = Directory(pdfsDirPath);
      if (!await pdfsDir.exists()) {
        await pdfsDir.create(recursive: true);
      }
      
      // Generate unique filename
      final String fileName = 'pdf_${DateTime.now().millisecondsSinceEpoch}${path.extension(pdfFile.path)}';
      final String filePath = path.join(pdfsDirPath, fileName);
      
      // Copy file to local storage
      await pdfFile.copy(filePath);
      
      return filePath;
    } catch (e) {
      throw Exception('Failed to save PDF file: $e');
    }
  }
  
  static Future<void> deleteImageFile(String filePath) async {
    try {
      final File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete image file: $e');
    }
  }
  
  static Future<void> deletePdfFile(String filePath) async {
    try {
      final File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete PDF file: $e');
    }
  }

  // ******** Web / Chrome specific helpers (existing methods remain unchanged) ********

  static Future<String> saveImageBytesWeb(Uint8List bytes) async {
    try {
      final String key = 'web_image_${DateTime.now().millisecondsSinceEpoch}';
      final String base64Data = base64Encode(bytes);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, base64Data);

      // Key can be stored/sent as a reference in place of a file path
      return key;
    } catch (e) {
      throw Exception('Failed to save web image bytes: $e');
    }
  }

  static Future<String> savePdfBytesWeb(Uint8List bytes) async {
    try {
      final String key = 'web_pdf_${DateTime.now().millisecondsSinceEpoch}';
      final String base64Data = base64Encode(bytes);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, base64Data);

      return key;
    } catch (e) {
      throw Exception('Failed to save web PDF bytes: $e');
    }
  }

  static Future<void> deleteImageBytesWeb(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      throw Exception('Failed to delete web image bytes: $e');
    }
  }

  static Future<void> deletePdfBytesWeb(String key) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      throw Exception('Failed to delete web PDF bytes: $e');
    }
  }
}