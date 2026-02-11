import 'package:flutter/material.dart';
// import 'dart:io';
import 'dart:typed_data';
// import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../services/flower_service.dart';

class AddFlowerScreen extends StatefulWidget {
  AddFlowerScreenState createState() => AddFlowerScreenState();
}

class AddFlowerScreenState extends State<AddFlowerScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // Web (Chrome) uploads as bytes
  Uint8List? webImageBytes;
  Uint8List? webPdfBytes;
  String? webPdfName;

  // Web (Chrome) specific upload functions - existing ones remain unchanged
  Future<void> uploadImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        webImageBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> uploadPdfWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        webPdfBytes = result.files.single.bytes;
        webPdfName = result.files.single.name;
      });
    }
  }

  void addFlowerWeb() async {
    final response = await FlowerService.addFlowerWeb(
      name: nameController.text,
      description: descriptionController.text,
      imageBytes: webImageBytes,
      pdfBytes: webPdfBytes,
    );
    print(response);
    if (response['message'] == 'Flower added successfully') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Flower added successfully!')));
      Navigator.of(context).pop();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Flower')),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter flower name',
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Enter flower description',
            ),
          ),

          // Web / Chrome image upload
          ElevatedButton(
            child: Text('Upload Image (Web)'),
            onPressed: uploadImageWeb,
          ),
          if (webImageBytes != null)
            Image.memory(
              webImageBytes!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),

          // Web / Chrome PDF upload
          ElevatedButton(
            child: Text('Upload Pdf (Web)'),
            onPressed: uploadPdfWeb,
          ),
          if (webPdfName != null) Text('Pdf Name (Web) :- $webPdfName'),

          // Web / Chrome Add Flower
          ElevatedButton(
            child: Text('Add Flower (Web)'),
            onPressed: addFlowerWeb,
          ),
        ],
      ),
    );
  }
}
