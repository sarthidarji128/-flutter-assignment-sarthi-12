import 'dart:io';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  // Cloudinary configuration
  static const String cloudName = 'dtvbnyhvn'; // Your Cloudinary cloud name
  // static const String cloudName = 'dilaghfpg'; // Your Cloudinary cloud name
  static const String uploadPreset = 'flower_app_preset'; // Your upload preset
  static const String apiKey = '193352296514226'; // Your API key (for deletion)
  // static const String apiKey = '193352296514226'; // Your API key (for deletion)
  
  static final CloudinaryPublic _cloudinary = CloudinaryPublic(
    cloudName,
    uploadPreset,
    cache: false,
  );

  /// Save image file to Cloudinary (equivalent to local storage saveImageFile)
  static Future<String> saveImageFile(File imageFile) async {
    try {
      // Upload to Cloudinary
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, resourceType: CloudinaryResourceType.Image),
      );
      
      // Return the secure URL of the uploaded image
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to save image file to Cloudinary: $e');
    }
  }

  /// Save PDF file to Cloudinary (equivalent to local storage savePdfFile)
  static Future<String> savePdfFile(File pdfFile) async {
    try {
      // Upload to Cloudinary with resource type as raw for PDF files
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(pdfFile.path, resourceType: CloudinaryResourceType.Raw),
      );
      
      // Return the secure URL of the uploaded PDF
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to save PDF file to Cloudinary: $e');
    }
  }

  /// Delete image file from Cloudinary (simple frontend implementation)
  static Future<void> deleteImageFile(String fileUrl) async {
    try {
      // Extract public ID from URL
      final publicId = _extractPublicId(fileUrl, 'image');
      
      if (publicId.isEmpty) {
        // ignore: avoid_print
        print('Warning: Could not extract public ID from URL: $fileUrl');
        return;
      }
      
      // For frontend-only apps, we'll just log the deletion request
      // Actual deletion should be handled via Cloudinary dashboard or backend
      // ignore: avoid_print
      print('Deletion requested for image: $publicId');
      print('Note: Files remain in Cloudinary. Delete manually from dashboard if needed.');
    } catch (e) {
      // ignore: avoid_print
      print('Warning: Failed to process image deletion request: $e');
      // Don't throw exception to avoid breaking app flow
    }
  }
  
  /// Delete PDF file from Cloudinary (simple frontend implementation)
  static Future<void> deletePdfFile(String fileUrl) async {
    try {
      // Extract public ID from URL
      final publicId = _extractPublicId(fileUrl, 'raw');
      
      if (publicId.isEmpty) {
        // ignore: avoid_print
        print('Warning: Could not extract public ID from URL: $fileUrl');
        return;
      }
      
      // For frontend-only apps, we'll just log the deletion request
      // Actual deletion should be handled via Cloudinary dashboard or backend
      // ignore: avoid_print
      print('Deletion requested for PDF: $publicId');
      print('Note: Files remain in Cloudinary. Delete manually from dashboard if needed.');
    } catch (e) {
      // ignore: avoid_print
      print('Warning: Failed to process PDF deletion request: $e');
      // Don't throw exception to avoid breaking app flow
    }
  }
  
  /// Get image file from Cloudinary (returns the URL)
  static String getImage(String fileUrl) {
    // For Cloudinary, the fileUrl is already the direct access URL
    // No additional processing needed
    return fileUrl;
  }
  
  /// Get PDF file from Cloudinary (returns the URL)
  static String getPdf(String fileUrl) {
    // For Cloudinary, the fileUrl is already the direct access URL
    // No additional processing needed
    return fileUrl;
  }
  
  /// Helper method to extract public ID from Cloudinary URL
  static String _extractPublicId(String url, String resourceType) {
    // Example URL: https://res.cloudinary.com/dilaghfpg/image/upload/v1234567890/flower_app/images/image_1234567890.jpg
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      
      // Find the segment with version number (starts with v followed by digits)
      int versionIndex = pathSegments.indexWhere((segment) => segment.startsWith('v') && RegExp(r'^v\d+').hasMatch(segment));
      
      if (versionIndex != -1 && versionIndex < pathSegments.length - 1) {
        // Join the segments after the version number
        final publicIdParts = pathSegments.skip(versionIndex + 1).toList();
        if (publicIdParts.isNotEmpty) {
          // Remove file extension
          final fileName = publicIdParts.last;
          final fileNameWithoutExt = fileName.split('.').first;
          publicIdParts[publicIdParts.length - 1] = fileNameWithoutExt;
          
          return publicIdParts.join('/');
        }
      }
      
      // Fallback: try to extract from the end of the URL
      final parts = url.split('/');
      if (parts.isNotEmpty) {
        final fileName = parts.last.split('?').first; // Remove query parameters
        return fileName.split('.').first; // Remove extension
      }
      
      return '';
    } catch (e) {
      // ignore: avoid_print
      print('Error extracting public ID: $e');
      return '';
    }
  }

  /// Alternative method using direct HTTP upload for more control
  static Future<String> uploadImageFileHttp(File imageFile) async {
    try {
      // Read file as bytes
      final bytes = await imageFile.readAsBytes();
      
      // Create multipart request
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);
      
      // Add file to request
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

  /// Alternative method for PDF upload using direct HTTP
  static Future<String> uploadPdfFileHttp(File pdfFile) async {
    try {
      // Read file as bytes
      final bytes = await pdfFile.readAsBytes();
      
      // Create multipart request
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/raw/upload');
      final request = http.MultipartRequest('POST', uri);
      
      // Add file to request
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: pdfFile.path.split('/').last,
      );
      
      request.files.add(multipartFile);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'flower_app/pdfs';
      request.fields['resource_type'] = 'raw';
      
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
      throw Exception('Failed to upload PDF via HTTP: $e');
    }
  }

  /// Upload image bytes (Uint8List) to Cloudinary for web platform
  static Future<String> uploadImageBytesWeb(Uint8List imageBytes, {String? filename}) async {
    try {
      // Create multipart request
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);
      
      // Generate filename if not provided
      final String fileName = filename ?? 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Add file to request
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

  /// Upload PDF bytes (Uint8List) to Cloudinary for web platform
  static Future<String> uploadPdfBytesWeb(Uint8List pdfBytes, {String? filename}) async {
    try {
      // Create multipart request
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/raw/upload');
      final request = http.MultipartRequest('POST', uri);
      
      // Generate filename if not provided
      final String fileName = filename ?? 'pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      // Add file to request
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        pdfBytes,
        filename: fileName,
      );
      
      request.files.add(multipartFile);
      request.fields['upload_preset'] = uploadPreset;
      request.fields['folder'] = 'flower_app/pdfs';
      request.fields['resource_type'] = 'raw';
      
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
      throw Exception('Failed to upload PDF bytes to Cloudinary: $e');
    }
  }

  /// Delete image from Cloudinary using URL (for web cleanup)
  static Future<void> deleteImageBytesWeb(String imageUrl) async {
    try {
      await deleteImageFile(imageUrl);
    } catch (e) {
      // Log error but don't throw to avoid breaking app flow
      print('Warning: Failed to delete image from Cloudinary: $e');
    }
  }

  /// Delete PDF from Cloudinary using URL (for web cleanup)
  static Future<void> deletePdfBytesWeb(String pdfUrl) async {
    try {
      await deletePdfFile(pdfUrl);
    } catch (e) {
      // Log error but don't throw to avoid breaking app flow
      print('Warning: Failed to delete PDF from Cloudinary: $e');
    }
  }
}