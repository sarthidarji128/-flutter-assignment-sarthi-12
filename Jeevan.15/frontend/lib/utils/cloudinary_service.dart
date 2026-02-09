import 'dart:io';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  static const String cloudName = '@@@@@@@@@@@@@@@';
  static const String uploadPreset = 'flower_app_preset';
  static const String apiKey = '@@@@@@@@@@@@@@@';
  
  static final CloudinaryPublic _cloudinary = CloudinaryPublic(
    cloudName,
    uploadPreset,
    cache: false,
  );

  static Future<String> saveImageFile(File imageFile) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, resourceType: CloudinaryResourceType.Image),
      );
      
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to save image file to Cloudinary: $e');
    }
  }

  static Future<String> savePdfFile(File pdfFile) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(pdfFile.path, resourceType: CloudinaryResourceType.Raw),
      );
      
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to save PDF file to Cloudinary: $e');
    }
  }

  static Future<void> deleteImageFile(String fileUrl) async {
    try {
      final publicId = _extractPublicId(fileUrl, 'image');
      
      if (publicId.isEmpty) {
        print('Warning: Could not extract public ID from URL: $fileUrl');
        return;
      }
      
      print('Deletion requested for image: $publicId');
      print('Note: Files remain in Cloudinary. Delete manually from dashboard if needed.');
    } catch (e) {
      print('Warning: Failed to process image deletion request: $e');
    }
  }
  
  static Future<void> deletePdfFile(String fileUrl) async {
    try {
      final publicId = _extractPublicId(fileUrl, 'raw');
      
      if (publicId.isEmpty) {
        print('Warning: Could not extract public ID from URL: $fileUrl');
        return;
      }
      
      print('Deletion requested for PDF: $publicId');
      print('Note: Files remain in Cloudinary. Delete manually from dashboard if needed.');
    } catch (e) {
      print('Warning: Failed to process PDF deletion request: $e');
    }
  }
  
  static String getImage(String fileUrl) {
    return fileUrl;
  }
  
  static String getPdf(String fileUrl) {
    return fileUrl;
  }
  
  static String _extractPublicId(String url, String resourceType) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      
      int versionIndex = pathSegments.indexWhere((segment) => segment.startsWith('v') && RegExp(r'^v\d+').hasMatch(segment));
      
      if (versionIndex != -1 && versionIndex < pathSegments.length - 1) {
        final publicIdParts = pathSegments.skip(versionIndex + 1).toList();
        if (publicIdParts.isNotEmpty) {
          final fileName = publicIdParts.last;
          final fileNameWithoutExt = fileName.split('.').first;
          publicIdParts[publicIdParts.length - 1] = fileNameWithoutExt;
          
          return publicIdParts.join('/');
        }
      }
      
      final parts = url.split('/');
      if (parts.isNotEmpty) {
        final fileName = parts.last.split('?').first;
        return fileName.split('.').first;
      }
      
      return '';
    } catch (e) {
      print('Error extracting public ID: $e');
      return '';
    }
  }

  static Future<String> uploadImageFileHttp(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);
      
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: imageFile.path.split('/').last,
      );
      
      request.files.add(multipartFile);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'flower_app/images';
      
      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['secure_url'];
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image via HTTP: $e');
    }
  }

  static Future<String> uploadPdfFileHttp(File pdfFile) async {
    try {
      final bytes = await pdfFile.readAsBytes();
      
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/raw/upload');
      final request = http.MultipartRequest('POST', uri);
      
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: pdfFile.path.split('/').last,
      );
      
      request.files.add(multipartFile);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'flower_app/pdfs';
      request.fields['resource_type'] = 'raw';
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['secure_url'];
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload PDF via HTTP: $e');
    }
  }

  static Future<String> uploadImageBytesWeb(Uint8List imageBytes, {String? filename}) async {
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);
      
      final String fileName = filename ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileName,
      );
      
      request.files.add(multipartFile);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'flower_app/images';
      
      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['secure_url'];
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image bytes to Cloudinary: $e');
    }
  }

  static Future<String> uploadPdfBytesWeb(Uint8List pdfBytes, {String? filename}) async {
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/raw/upload');
      final request = http.MultipartRequest('POST', uri);
      
      final String fileName = filename ?? 'pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        pdfBytes,
        filename: fileName,
      );
      
      request.files.add(multipartFile);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'flower_app/pdfs';
      request.fields['resource_type'] = 'raw';
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        return jsonResponse['secure_url'];
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload PDF bytes to Cloudinary: $e');
    }
  }

  static Future<void> deleteImageBytesWeb(String imageUrl) async {
    try {
      await deleteImageFile(imageUrl);
    } catch (e) {
      print('Warning: Failed to delete image from Cloudinary: $e');
    }
  }
  static Future<void> deletePdfBytesWeb(String pdfUrl) async {
    try {
      await deletePdfFile(pdfUrl);
    } catch (e) {
      print('Warning: Failed to delete PDF from Cloudinary: $e');
    }
  }
}